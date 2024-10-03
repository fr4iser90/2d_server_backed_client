# DatabaseGodotCharacterFetchHandler.gd
extends Node

signal backend_characters_fetched(peer_id, processed_characters)

var websocket_multiplayer_manager
var network_endpoint_manager = null
var user_session_manager = null
var stored_peer_id 
var is_initialized = false


func initialize():
	if is_initialized:
		return
	network_endpoint_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_endpoint_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	websocket_multiplayer_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_middleware_manager")
	is_initialized = true

# This function processes the character fetch and returns the result back to the client handler
func process_fetch_characters(peer_id: int):
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


func handle_all_character_for_user(packet: Dictionary):
	var characters = packet.get("characters", [])
	if characters.size() > 0:
		print("packetpacketpacketpacket:", packet)
		print("Fetched characters: ", characters)
		# Clean character data and emit signal
		var cleaned_characters = []
		for character in characters:
			cleaned_characters.append(clean_character_data(character))
		# Save the cleaned characters in the session for the peer
		save_characters_in_session(stored_peer_id, characters)
		# Emit the signal to send the cleaned characters back to the client
		emit_signal("backend_characters_fetched", stored_peer_id, cleaned_characters)
	else:
		print("No characters found for user in packet.")


func save_characters_in_session(peer_id: int, characters: Array):
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	var existing_characters = user_session_manager.get_characters_for_peer(peer_id)

	if existing_characters != null:
		for character in characters:
			var session_character_data = clean_character_user_session_manager_data(character)
			var found = false

			for i in range(len(existing_characters)):
				if existing_characters[i].get("character_class") == session_character_data.get("character_class"):
					existing_characters[i] = session_character_data
					found = true
					break

			if not found:
				existing_characters.append(session_character_data)

		user_session_manager.store_characters_for_peer(peer_id, existing_characters)
	else:
		var new_characters = []
		for character in characters:
			var session_character_data = clean_character_user_session_manager_data(character)
			new_characters.append(session_character_data)
		user_session_manager.store_characters_for_peer(peer_id, new_characters)

# Clean character data for UserSessionManager
func clean_character_user_session_manager_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)
	cleaned_data.erase("inventory")
	cleaned_data.erase("equipment")
	return cleaned_data

# Clean character data before sending to the client
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)
	cleaned_data.erase("user")
	cleaned_data.erase("id")
	cleaned_data.erase("_id")
	return cleaned_data

func get_stored_database_session_token_for_peer(peer_id: int) -> String:
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	return user_session_manager.get_database_session_token_for_peer(peer_id)
