extends Node

var core_tree
var network_tree
var user_tree
var game_tree
var menu_tree
var client_main

func _ready():
	if GlobalManager:
		print("GlobalManager available, waiting for signal")
		GlobalManager.connect("global_manager_ready", Callable(self, "_on_global_manager_ready"))
		_check_global_manager_status()
	else:
		_retry_check_global_manager()

func _retry_check_global_manager():
	var timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", Callable(self, "_ready"))
	timer.start()

func _check_global_manager_status():
	GlobalManager._check_node_manager_readiness()

func _on_global_manager_ready():
	_build_tree()

# Load the trees and initialize them if needed
func _build_tree():
	# Load CoreTree and initialize it
	core_tree = GlobalManager.SceneManager.load_scene("CoreTree")
	if core_tree and core_tree.has_method("initialize"):
		core_tree.initialize()
		print("CoreTree initialized")
	
	# Load UserTree and initialize it
	user_tree = GlobalManager.SceneManager.load_scene("UserTree")
	if user_tree and user_tree.has_method("initialize"):
		user_tree.initialize()
		print("UserTree initialized")

	# Load GameTree and initialize it
	game_tree = GlobalManager.SceneManager.load_scene("GameTree")
	if game_tree and game_tree.has_method("initialize"):
		game_tree.initialize()
		print("GameTree initialized")
		
	client_main = GlobalManager.SceneManager.load_scene("ClientMain")
	if client_main and client_main.has_method("initialize"):
		client_main.initialize()
		print("ClientMain initialized")
	
	# Defer adding NetworkTree to ensure the others are loaded first
	call_deferred("_add_network")

# Add the NetworkTree and initialize it
func _add_network():
	network_tree = GlobalManager.SceneManager.put_scene_at_node("NetworkTree", "Core")
	if network_tree and network_tree.has_method("initialize"):
		network_tree.initialize()
		print("NetworkTree initialized and added to Core")

	# Proceed to finish building the tree and switch scenes
	call_deferred("_tree_finished")

# Final step: Switch to the main menu after all trees are initialized
func _tree_finished(): 
	GlobalManager.SceneManager.put_scene_at_node("LauncherTree", "Menu")
	print("Switched to Launcher")
	queue_free() 
