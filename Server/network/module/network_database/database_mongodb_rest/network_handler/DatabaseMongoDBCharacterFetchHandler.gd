# DatabaseMongoDBCharacterFetchHandler.gd
extends Node

signal backend_characters_fetched(peer_id, processed_characters)

var network_endpoint_manager = null
var user_session_manager = null
var is_initialized = false

func initialize():
	if is_initialized:
		return
	network_endpoint_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkEndpointManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	is_initialized = true

# This function processes the character fetch and returns the result back to the client handler
func process_fetch_characters(peer_id: int):
	var route_info = network_endpoint_manager.get_route("/characters")
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_error("No route found for '/characters'", self)
		return

	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Authorization: Bearer " + get_stored_database_session_token_for_peer(peer_id)]

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_backend_characters_response").bind(peer_id))
	var err = http_request.request(backend_url, headers, HTTPClient.METHOD_GET)

	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send request to backend for characters", self)

func _on_backend_characters_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var characters = json.get_data()

			# Clean character data before sending to the client
			var cleaned_characters = []
			for character in characters:
				var cleaned_character = clean_character_data(character)
				cleaned_characters.append(cleaned_character)

			# Save characters in session
			save_characters_in_session(peer_id, characters)

			# Emit signal to send the processed data back to the client handler
			emit_signal("backend_characters_fetched", peer_id, cleaned_characters)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse backend character data", self)
	else:
		GlobalManager.DebugPrint.debug_error("Backend character fetch failed with response code: " + str(response_code), self)

func save_characters_in_session(peer_id: int, characters: Array):
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
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
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	return user_session_manager.get_database_session_token_for_peer(peer_id)
