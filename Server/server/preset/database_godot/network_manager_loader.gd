# res://src/core/server/preset/database_godot/network_manager_loader.gd
extends Node


var network_server_game_module
var network_server_databse_module
var network_server_database_manager
var network_server_client_manager
var network_handler

# Initialisiert die Netzwerk-Manager
func load_network_managers():
	network_server_game_module = GlobalManager.SceneManager.put_scene_at_node("NetworkGameUDPENetPeerModule", "Network")
	network_server_databse_module = GlobalManager.SceneManager.put_scene_at_node("NetworkDatabaseGodotWebsocketModule", "Network")
	network_server_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkServerClientManager")
	network_server_database_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkServerDatabaseManager")
	call_deferred("_initialize_network_nodes")


# Initialisiert die Netzwerkknoten
func _initialize_network_nodes():
	network_server_client_manager.initialize()
	network_server_database_manager.initialize()
	_check_if_managers_loaded()

# Überprüft, ob die Manager geladen sind
func _check_if_managers_loaded():
	if network_server_client_manager and network_server_database_manager:
		print("Network Server Client Manager and GodotDatabase + Websocket Manager loaded.")
		var server_console = GlobalManager.NodeManager.get_cached_node("server_console", "server_console")
		server_console.connect_to_database()
		emit_signal("network_game_database_module_intialized")
	else:
		print("Waiting for managers to be loaded...")
		call_deferred("_check_if_managers_loaded")
