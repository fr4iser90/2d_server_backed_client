# res://src/core/server/preset/default/network_manager_loader.gd
extends Node

var network_tree
var network_server_game_module
var network_server_databse_module
var network_handler

signal managers_loaded


# Initialisiert die Netzwerk-Manager
func load_network_managers():
	call_deferred("_initialize_network_nodes")

# Initialisiert die Netzwerkknoten
func _initialize_network_nodes():
	network_tree = GlobalManager.SceneManager.put_scene_at_node("NetworkTree", "Core")
	network_server_game_module = GlobalManager.SceneManager.put_scene_at_node("NetworkGameUDPENetPeerModule", "Core/Network")
	network_server_databse_module = GlobalManager.SceneManager.put_scene_at_node("NetworkDatabaseMongoDBRESTModule", "Core/Network")
	network_server_game_module.initialize()
	network_server_databse_module.initialize()
	_check_if_managers_loaded()

	
# Überprüft, ob die Manager geladen sind
func _check_if_managers_loaded():
	if network_server_game_module and network_server_databse_module:
		print("Network Server Client Manager and Backend Manager loaded.")
		emit_signal("managers_loaded")
	else:
		print("Waiting for managers to be loaded...")
		call_deferred("_check_if_managers_loaded")
