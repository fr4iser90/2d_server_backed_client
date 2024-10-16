# CharFetchHandler.gd
extends Node

var enet_server_manager 
var user_session_manager
var character_manager
var backend_handler 
var handler_name = "CharacterFetchService"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetServerManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	character_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "CharacterManager")
	backend_handler = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModuleService", "DatabaseCharacterFetchService")
	
	# Connect signal from backend handler to process character fetch response
	backend_handler.connect("backend_characters_fetched", Callable(self, "_on_backend_characters_fetched"))
	is_initialized = true

# Handle incoming packet from the client
func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("session_token"):
		var server_session_token = client_data["session_token"]
		var database_session_token = user_session_manager.get_database_session_token_for_peer(peer_id)
		backend_handler.process_fetch_characters(peer_id)
	else:
		GlobalManager.DebugPrint.debug_error("Character fetch failed: Missing session token", self)

# Receive the processed character data from the backend handler and send it to the client
func _on_backend_characters_fetched(peer_id: int, processed_characters: Array):
	print("processed_characters :", processed_characters)
	var characters_data = character_manager.clean_characters_data(processed_characters)
	var err = enet_server_manager.send_packet(peer_id, handler_name, {"characters": characters_data})
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send character fetch packet to peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_info("Character fetch packet sent successfully to peer_id: " + str(peer_id), self)
