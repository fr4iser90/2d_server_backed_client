# res://src/core/autoloads/global_manager.gd
extends Node

# Declare the global variables directly in GlobalManager
var GlobalConfig = null
var GlobalNodeConfig = null
var GlobalNodeManager = null
var GlobalSceneConfig = null
var GlobalSceneManager = null
var GlobalServerConsolePrint = null

var autoloads = [
	{"name": "GlobalConfig", "path": "res://src/core/autoloads/global_config.gd"},
	{"name": "GlobalSceneScanner", "path": "res://src/core/autoloads/global_scene_scanner.gd"},
	{"name": "GlobalNodeConfig", "path": "res://src/core/autoloads/global_node_config.gd"},
	{"name": "GlobalNodeManager", "path": "res://src/core/autoloads/global_node_manager.gd"},
	{"name": "GlobalSceneConfig", "path": "res://src/core/autoloads/global_scene_config.gd"},
	{"name": "GlobalSceneManager", "path": "res://src/core/autoloads/global_scene_manager.gd"},
]

var all_autoloads_loaded = false
signal global_manager_ready

func _ready():
	print("GlobalManager initialized.")
	group_autoloads()

# This function dynamically loads and sets autoloads in Globals
func group_autoloads():
	all_autoloads_loaded = true  # Track whether all autoloads are loaded
	for autoload in autoloads:
		var resource = ResourceLoader.load(autoload["path"])
		if resource is PackedScene:
			var instance = resource.instance()
			instance.set_name(autoload["name"])
			add_child(instance)
			self.set(autoload["name"], instance)
		elif resource is Script:
			var instance = resource.new()
			instance.set_name(autoload["name"])
			add_child(instance)
			self.set(autoload["name"], instance)
		else:
			print("Error loading: " + autoload["path"])
			all_autoloads_loaded = false  # Mark as failed if loading didn't succeed
	
	if all_autoloads_loaded:
		emit_signal("global_manager_ready")
	else:
		print("Some autoloads failed to load. GlobalManager will not signal readiness.")

func check_all_managers_ready():
	if all_autoloads_loaded:
		emit_signal("global_manager_ready")
	else:
		print("Autoloads not ready yet.")

func get_global(name: String) -> Node:
	if self.get(name) != null:
		return get(name)
	else:
		print("Global " + name + " not found!")
		return null
