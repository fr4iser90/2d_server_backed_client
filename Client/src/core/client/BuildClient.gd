extends Node

var core_tree
var network_tree
var user_session_module
var game_player_module
var game_world_module
var game_level_module
var user_session_manager
var client_server_manager
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
	call_deferred("_build_tree")

# Load the trees and initialize them if needed
func _build_tree():
	# Load UserTree and initialize it
	user_session_module = GlobalManager.SceneManager.put_scene_at_node("UserSessionModule", "User")
	if user_session_module:
		print("UserSessionModule successfully loaded and added to root.")
		GlobalManager.NodeManager.scan_and_register_all_nodes(user_session_module)
	else:
		print("Failed to load UserSessionModule.")

	# Check GamePlayerModule and add it
	game_player_module = GlobalManager.SceneManager.put_scene_at_node("GamePlayerModule", "Game")
	if game_player_module:
		print("GamePlayerModule successfully loaded and added to root.")
	else:
		print("Failed to load GamePlayerModule.")

	# Check GameWorldModule and add it
	game_world_module = GlobalManager.SceneManager.put_scene_at_node("GameWorldModule", "Game")
	if game_world_module:
		print("GameWorldModule successfully loaded and added to root.")
	else:
		print("Failed to load GameWorldModule.")

	# Check GameLevelModule and add it
	game_level_module = GlobalManager.SceneManager.put_scene_at_node("GameLevelModule", "Game")
	if game_level_module:
		print("GameLevelModule successfully loaded and added to root.")
	else:
		print("Failed to load GameLevelModule.")
		
	client_main = GlobalManager.SceneManager.load_scene("ClientMain")
	if client_main and client_main.has_method("initialize"):
		client_main.initialize()
		print("ClientMain initialized")
		
	# Defer adding NetworkTree to ensure the others are loaded first
	call_deferred("_add_network")

# Add the NetworkTree and initialize it
func _add_network():
	network_tree = GlobalManager.SceneManager.put_scene_at_node("NetworkGameModule", "Network")
	client_server_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	client_server_manager.initialize()

	# Proceed to finish building the tree and switch scenes
	call_deferred("_tree_finished")

# Final step: Switch to the main menu after all trees are initialized
func _tree_finished(): 
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	GlobalManager.SceneManager.put_scene_at_node("LauncherModule", "Menu")
	print("Switched to Launcher")
	queue_free() 
