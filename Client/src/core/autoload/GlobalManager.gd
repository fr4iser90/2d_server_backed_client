extends Node

# Globale Variablen
var GlobalConfig = null
var NodeManager = null
var SceneManager = null
var SignalManager = null
var GlobalServerConsolePrint = null
var node_manager_ready = false
var scene_manager_ready = false

var autoloads = [
	{"name": "GlobalConfig", "path": "res://src/core/autoload/GlobalConfig.gd"},
	{"name": "NodeManager", "path": "res://src/core/autoload/NodeManager.gd"},
	{"name": "SceneManager", "path": "res://src/core/autoload/SceneManager.gd"},
]

signal global_manager_ready

func _ready():
	print("GlobalManager initialized.")
	load_autoloads()
	_check_node_manager_readiness()

func _check_node_manager_readiness():
	if GlobalManager.NodeManager.ready and GlobalManager.SceneManager.ready:
		print("All Managers are ready! GlobalManager ready!")
		emit_signal("global_manager_ready")
	else:
		print("Node Manager not ready yet, retrying...")
		# Retry after a short delay
		var timer = Timer.new()
		timer.set_wait_time(1.0)  # Retry every 1 second
		timer.set_one_shot(true)
		add_child(timer)
		timer.connect("timeout", Callable(self, "_check_node_manager_readiness"))
		timer.start()
		
# Funktion zum Laden der Autoloads
func load_autoloads():
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
				continue

			instance.set_name(autoload["name"])
			add_child(instance)
			self.set(autoload["name"], instance)
		else:
			print("Error loading: " + autoload["path"])

	# Verbinde Signale für NodeManager und SceneManager
	NodeManager.connect("node_manager_ready", Callable(self, "_on_node_manager_ready"))
	SceneManager.connect("scene_manager_ready", Callable(self, "_on_scene_manager_ready"))
	
	
func _on_node_manager_ready():
	print("on_node_manager ready true")
	node_manager_ready = true
	check_all_managers_ready()

func _on_scene_manager_ready():
	scene_manager_ready = true
	check_all_managers_ready()

func _check_node_manager():
	NodeManager.check_node_manager_readiness()
	check_all_managers_ready()
	
func _check_scene_manager():
	SceneManager.check_scene_manager_readiness()
	check_all_managers_ready()
	
# Prüfen, ob alle Manager bereit sind
func check_all_managers_ready():
	if node_manager_ready and scene_manager_ready:
		print("All Managers are ready! GlobalManagerReady")
		emit_signal("global_manager_ready")


func get_global(name: String) -> Node:
	if self.get(name) != null:
		return get(name)
	else:
		print("Global " + name + " not found!")
		return null
