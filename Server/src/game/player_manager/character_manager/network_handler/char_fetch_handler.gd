#  res://src/game/player_manager/character_manager/network_handler/char_fetch_handler.gd SERVER
extends Node

var backend_routes_manager
var enet_server_manager
var handler_name = "char_fetch_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("handle_backend_login already initialized. Skipping.", self)
		return

	# Initialisiere die Manager
	backend_routes_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_manager", "enet_server_manager")
	is_initialized = true

# Function to handle incoming packet (request from client)
func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("session_token"):
		var session_token = client_data["session_token"]
		GlobalManager.DebugPrint.debug_info("Session token received for character fetch: " + session_token, self)

		# Validate session token for the peer
		if not validate_session_token(session_token, peer_id):
			GlobalManager.DebugPrint.debug_error("Session token validation failed for peer: " + str(peer_id), self)
			return
		
		# Fetch character data from the backend
		fetch_characters_from_backend(peer_id)
	else:
		GlobalManager.DebugPrint.debug_error("Character fetch failed: Missing session token", self)

# Function to validate session token (dummy example, replace with your validation logic)
func validate_session_token(session_token: String, peer_id: int) -> bool:
	# Assume user_session_manager has a method to check the validity of session tokens
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	var stored_session_token = user_session_manager.get_session_token_for_peer(peer_id)
	return session_token == stored_session_token

# Dummy function to get the stored auth token (replace with your logic)
func get_stored_auth_token_for_peer(peer_id: int) -> String:
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	return user_session_manager.get_auth_token_for_peer(peer_id)
	
# Function to fetch character data from the backend
func fetch_characters_from_backend(peer_id: int):
	var route_info = backend_routes_manager.get_route("/characters")

	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_warning("Error: No route found for 'characters'", self)
		return

	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Authorization: Bearer " + get_stored_auth_token_for_peer(peer_id)]

	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.connect("request_completed", Callable(self, "_on_backend_characters_response").bind(peer_id))
	var err = http_request.request(backend_url, headers, HTTPClient.METHOD_GET)

	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send request to backend for characters, error code: " + str(err), self)

func _on_backend_characters_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var characters = json.get_data()
			# Clean the character data before sending it to the client
			var cleaned_characters = []
			for character in characters:
				var cleaned_character = clean_character_data(character)
				cleaned_characters.append(cleaned_character)

			# Create the response data dictionary
			var response_data = {
				"characters": cleaned_characters
			}
			
			# Send the packet to the peer via the enet_server_manager
			print("response_data : FETCH", response_data)
			save_characters_in_session(peer_id, characters)
			var err = enet_server_manager.send_packet(peer_id, handler_name, response_data)
			if err != OK:
				GlobalManager.DebugPrint.debug_error("Failed to send packet: " + str(err), self)
			else:
				GlobalManager.DebugPrint.debug_info("Characters sent successfully to peer: " + str(peer_id), self)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse character data.", self)
	else:
		GlobalManager.DebugPrint.debug_error("Backend returned an error: " + str(response_code), self)

func save_characters_in_session(peer_id: int, characters: Array):
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")

	# Abrufen der bereits gespeicherten Charaktere für den peer_id
	var existing_characters = user_session_manager.get_characters_for_peer(peer_id)

	# Wenn es bereits gespeicherte Charaktere gibt, werden sie aktualisiert bzw. neue Charaktere hinzugefügt
	if existing_characters != null:
		for character in characters:
			var session_character_data = clean_character_user_session_manager_data(character)
			var found = false

			# Prüfen, ob der Charakter bereits in den gespeicherten Daten vorhanden ist
			for i in range(len(existing_characters)):
				if existing_characters[i].get("character_class") == session_character_data.get("character_class"):
					# Wenn der Charakter bereits existiert, aktualisiere ihn
					existing_characters[i] = session_character_data
					found = true
					break

			# Wenn der Charakter nicht existiert, füge ihn hinzu
			if not found:
				existing_characters.append(session_character_data)

		# Speichere die aktualisierten Charaktere
		user_session_manager.store_characters_for_peer(peer_id, existing_characters)
	else:
		# Falls keine Charaktere gespeichert sind, speichere alle neuen Charaktere
		var new_characters = []
		for character in characters:
			var session_character_data = clean_character_user_session_manager_data(character)
			new_characters.append(session_character_data)
		user_session_manager.store_characters_for_peer(peer_id, new_characters)
		
# Bereinigung der Charakterdaten für den UserSessionManager
func clean_character_user_session_manager_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)
	# Entferne Felder, die der UserSessionManager nicht benötigt
	cleaned_data.erase("inventory")
	cleaned_data.erase("equipment")
	cleaned_data.erase("attributes")
	cleaned_data.erase("inventory_summary")
	cleaned_data.erase("skills")
	cleaned_data.erase("karma_points")
	cleaned_data.erase("beyond_points")
	cleaned_data.erase("level")
	cleaned_data.erase("experience")
	cleaned_data.erase("current_area")
	cleaned_data.erase("experience")
	# Füge nur relevante Daten für den UserSessionManager hinzu
	return cleaned_data	
	
# Clean character data before sending it to the client
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)  # Duplicate to avoid modifying original data
	# Remove fields that the client shouldn't see
	cleaned_data.erase("user")  # Remove user-related data
	cleaned_data.erase("id")  # Remove internal ID
	cleaned_data.erase("_id")  # Remove internal MongoDB ID
	return cleaned_data
