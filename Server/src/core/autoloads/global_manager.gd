extends Node

# Declare the global variables directly in GlobalManager
var GlobalConfig = null
var GlobalNodeManager = null
var GlobalSceneManager = null
var GlobalServerConsolePrint = null
var node_manager_ready = false
var scene_manager_ready = false

var autoloads = [
	{"name": "GlobalConfig", "path": "res://src/core/autoloads/global_config.gd"},
	{"name": "GlobalSceneScanner", "path": "res://src/core/autoloads/global_scene_scanner.gd"},
	{"name": "GlobalNodeManager", "path": "res://src/core/autoloads/global_node_manager.gd"},
	{"name": "GlobalSceneManager", "path": "res://src/core/autoloads/global_scene_manager.gd"},
	{"name": "GlobalServerConsolePrint", "path": "res://src/core/autoloads/global_server_console_print.gd"},
]

var all_autoloads_loaded = false
var check_timer = null

signal global_manager_ready

func _ready():
	print("GlobalManager initialized.")
	group_autoloads()
	setup_timer()

# This function dynamically loads and sets autoloads in Globals
func group_autoloads():
	all_autoloads_loaded = true  # Track whether all autoloads are loaded

	for autoload in autoloads:
		var resource = ResourceLoader.load(autoload["path"])
		if resource:
			var instance
			if resource is PackedScene:
				instance = resource.instance()
			elif resource is Script:
				instance = resource.new()
			else:
				print("Error loading: " + autoload["path"])
				all_autoloads_loaded = false  # Mark as failed if loading didn't succeed
				continue

			instance.set_name(autoload["name"])
			add_child(instance)
			self.set(autoload["name"], instance)
		else:
			print("Error loading: " + autoload["path"])
			all_autoloads_loaded = false  # Mark as failed if loading didn't succeed

	# Connect signals if the autoloads are loaded
	if all_autoloads_loaded:
		GlobalNodeManager.connect("node_manager_ready", Callable(self, "_on_node_manager_ready"))
		GlobalSceneManager.connect("scene_manager_ready", Callable(self, "_on_scene_manager_ready"))

	# Set up a timer to periodically check if the managers are ready
	if not check_timer:
		setup_timer()

func setup_timer():
	check_timer = Timer.new()
	check_timer.wait_time = 1.0  # Check every second
	check_timer.one_shot = false
	check_timer.connect("timeout", Callable(self, "_check_managers_ready"))
	add_child(check_timer)
	check_timer.start()

func _on_node_manager_ready():
	node_manager_ready = true
	# No direct call to _check_managers_ready here

func _on_scene_manager_ready():
	scene_manager_ready = true
	# No direct call to _check_managers_ready here

func _check_managers_ready():
	if all_autoloads_loaded and node_manager_ready and scene_manager_ready:
		if !check_timer.is_stopped():
			print("All Managers ready Node and Scene too")
			emit_signal("global_manager_ready")
			check_timer.stop()  # Stop the timer once everything is ready
	else:
		GlobalNodeManager.check_node_manager_readiness()
		GlobalSceneManager.check_scene_manager_readiness()
		print("Autoloads or Managers not ready yet.")

func get_global(name: String) -> Node:
	if self.get(name) != null:
		return get(name)
	else:
		print("Global " + name + " not found!")
		return null
