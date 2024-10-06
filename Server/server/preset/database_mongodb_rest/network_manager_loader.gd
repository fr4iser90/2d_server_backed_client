# res://src/core/server/preset/default/network_manager_loader.gd
extends Node

var network_tree
var network_server_game_module
var network_server_databse_module
var network_handler

# Initialisiert die Netzwerk-Manager
func load_network_managers():
	call_deferred("_initialize_network_nodes")

# Initialisiert die Netzwerkknoten
func _initialize_network_nodes():
	network_server_game_module = GlobalManager.SceneManager.put_scene_at_node("NetworkGameUDPENetPeerModule", "Network")
	network_server_databse_module = GlobalManager.SceneManager.put_scene_at_node("NetworkDatabaseMongoDBRESTModule", "Network")
#	GlobalManager.SceneManager.scan_runtime_node_map()
	network_server_game_module.initialize()
	network_server_databse_module.initialize()
	call_deferred("_check_if_managers_loaded()")

# Überprüft, ob die Manager geladen sind
func _check_if_managers_loaded():
	if network_server_game_module and network_server_databse_module:
		print("Network Server Client Manager and Backend Manager loaded.")
		var server_console = GlobalManager.NodeManager.get_cached_node("server_manager", "server_console")
		#_reference_nodes()
		server_console.connect_to_database()
		emit_signal("network_game_database_module_intialized")
	else:
		print("Waiting for managers to be loaded...")
		call_deferred("_check_if_managers_loaded")


# Reference backend managers and handlers
func _reference_nodes():
	GlobalManager.DebugPrint.debug_info("Referencing backend managers and handlers...", self)
	GlobalManager.NodeManager.reference_map_entry("NetworkDatabaseMap", "network_database_module")
	GlobalManager.NodeManager.reference_map_entry("NetworkDatabaseMap", "network_database_handler")


