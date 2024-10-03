# CharFetchHandler.gd
extends Node

var enet_server_manager 
var user_session_manager
var backend_handler 
var handler_name = "character_fetch_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	backend_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_character_fetch_handler")
	
	# Connect signal from backend handler to process character fetch response
	backend_handler.connect("backend_characters_fetched", Callable(self, "_on_backend_characters_fetched"))
	is_initialized = true

# Handle incoming packet from the client
func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("session_token"):
		var server_session_token = client_data["session_token"]
		var database_session_token = user_session_manager.get_database_session_token_for_peer(peer_id)
		backend_handler.process_fetch_characters(peer_id, database_session_token)
	else:
		GlobalManager.DebugPrint.debug_error("Character fetch failed: Missing session token", self)

# Receive the processed character data from the backend handler and send it to the client
func _on_backend_characters_fetched(peer_id: int, processed_characters: Array):
	var err = enet_server_manager.send_packet(peer_id, handler_name, {"characters": processed_characters})
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send character fetch packet to peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_info("Character fetch packet sent successfully to peer_id: " + str(peer_id), self)
