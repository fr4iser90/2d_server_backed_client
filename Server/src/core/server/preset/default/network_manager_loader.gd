# res://src/core/server/preset/default/network_manager_loader.gd
extends Node

var network_tree
var network_server_client_manager
var network_server_backend_manager
var network_handler

signal managers_loaded

# Initialisiert die Netzwerk-Manager
func load_network_managers():
	call_deferred("_initialize_network_nodes")

# Initialisiert die Netzwerkknoten
func _initialize_network_nodes():
	network_tree = GlobalManager.SceneManager.put_scene_at_node("NetworkTree", "Core")
	network_server_client_manager = GlobalManager.SceneManager.put_scene_at_node("NetworkServerClientManager", "Core/Network")
	network_server_backend_manager = GlobalManager.SceneManager.put_scene_at_node("NetworkServerBackendManager", "Core/Network")
	network_server_client_manager.initialize()
	network_server_backend_manager.initialize()
	_check_if_managers_loaded()
	GlobalManager.GlobalServerConsolePrint.print_to_console("NetworkModules initialized")
	
# Überprüft, ob die Manager geladen sind
func _check_if_managers_loaded():
	if network_server_client_manager and network_server_backend_manager:
		print("Network Server Client Manager and Backend Manager loaded.")
		emit_signal("managers_loaded")
	else:
		print("Waiting for managers to be loaded...")
		call_deferred("_check_if_managers_loaded")
