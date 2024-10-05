extends Node


signal peer_disconnected(peer_id: int)

@onready var network_enet_server_manager = $"../.."

var character_manager

var is_initialized = false


func initialize():
	if is_initialized:
		return
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	is_initialized = true

func handle_peer_disconnected(peer_id: int,  connected_peers: Dictionary):
	if not is_initialized:
		initialize()
	GlobalManager.DebugPrint.debug_info("Peer disconnected with ID: " + str(peer_id), self)
	var database_character_update_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_character_update_handler")
	var character_data = character_manager.get_character_data(peer_id)
	
	print("character_data will update : ", character_data)
#	var character_id = character_data["character_id"]
#	database_character_update_handler.process_character_update(peer_id, character_id, character_data)
	network_enet_server_manager.connected_peers.erase(peer_id)  # Remove the peer from the connected list
	
	# Liste von Managern, die die Peer-ID löschen müssen
	var manager_list = [
		{"manager": "world_manager", "node": "instance_manager", "remove_function": "remove_player_from_instance"},
		{"manager": "game_manager", "node": "player_movement_manager", "remove_function": "remove_player"},
		{"manager": "user_manager", "node": "user_session_manager", "remove_function": "remove_user"},
		{"manager": "game_manager", "node": "character_manager", "remove_function": "remove_character"}
	]

	# Iteriere durch die Liste und entferne die Peer-ID dynamisch
	for manager_data in manager_list:
		var manager = GlobalManager.NodeManager.get_cached_node(manager_data["manager"], manager_data["node"])
		if manager and manager.has_method(manager_data["remove_function"]):
			manager.call(manager_data["remove_function"], peer_id)
			GlobalManager.DebugPrint.debug_info(manager_data["remove_function"] + " called for " + manager_data["node"] + " with peer_id: " + str(peer_id), self)
		else:
			GlobalManager.DebugPrint.debug_warning("Manager or function not found: " + manager_data["node"], self)
	
	emit_signal("peer_disconnected", peer_id)
