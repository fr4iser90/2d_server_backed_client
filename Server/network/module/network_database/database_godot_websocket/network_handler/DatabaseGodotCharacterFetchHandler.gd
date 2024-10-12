# DatabaseGodotCharacterFetchHandler.gd
extends Node

signal backend_characters_fetched(peer_id, processed_characters)

var websocket_multiplayer_manager
var network_endpoint_manager = null
var user_session_manager = null
var character_manager
var stored_peer_id 
var is_initialized = false


func initialize():
	if is_initialized:
		return
	network_endpoint_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkEndpointManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	character_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "CharacterManager")
	websocket_multiplayer_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkMiddlewareManager")
	is_initialized = true

# This function processes the character fetch and returns the result back to the client handler
func process_fetch_characters(peer_id: int):
	if not is_initialized:
		initialize()
	stored_peer_id = peer_id  # Store the ENet peer_id for later use
	var websocket_peer = websocket_multiplayer_manager.get_websocket_peer()
	var user_id = user_session_manager.get_user_id(peer_id)
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		var char_fetch_packet = {
			"type": "character",  # Specify packet type for login
			"action": "fetch_all_characters",
			"user_id": user_id,
		}
		var json_str = JSON.stringify(char_fetch_packet)
		websocket_peer.set_target_peer(1)  # Assuming 1 is the server ID
		websocket_peer.put_packet(json_str.to_utf8_buffer())
	else:
		print("WebSocket is not connected, unable to send CharacterFetch  data")

# Handle the raw character data received from the backend and forward it to the CharacterManager
func handle_all_character_for_user(packet: Dictionary):
	var characters = packet.get("characters", [])
	if characters.size() > 0:
		print("characters received: ", characters)
		
		# 1. Add all characters to CharacterManager (full data and lightweight data)
		character_manager.add_all_characters_data(stored_peer_id, characters)
		
		# 2. Extract sensitive data and store it internally
		for character in characters:
			var sensitive_data = character_manager.get_sensitive_data(character)
			character_manager.store_sensitive_data(stored_peer_id, sensitive_data)  # Store sensitive data for each character
		
		# 3. Fetch the lightweight character data from CharacterManager
		var lightweight_characters_data = character_manager.lightweight_characters_data.get(stored_peer_id, [])
		
		# 4. Emit signal to notify that backend characters are fetched
		emit_signal("backend_characters_fetched", stored_peer_id, lightweight_characters_data)
	else:
		print("No characters found for user in packet.")

