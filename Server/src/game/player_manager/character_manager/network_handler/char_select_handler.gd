extends Node

signal character_selected_success(peer_id: int, character_data: Dictionary)
signal character_selection_failed(reason: String)

var backend_routes_manager
var enet_server_manager
var user_session_manager
var instance_manager
var character_manager
var handler_name = "char_select_handler"
var debug_enabled = true
var is_initialized = false

func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("handle_backend_login already initialized. Skipping.", self)
		return
	
	# Setze den Debug-Modus für dieses Skript (true oder false)
	GlobalManager.DebugPrint.set_debug_enabled(debug_enabled)
	# Optional: Du kannst hier auch das Debug-Level pro Modul setzen, falls notwendig
	GlobalManager.DebugPrint.set_debug_level(GlobalManager.DebugPrint.DebugLevel.WARNING)

	# Initialisiere die Manager
	backend_routes_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_manager", "enet_server_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	is_initialized = true

# Handle incoming packet from the client
func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("session_token") and client_data.has("character_class"):
		var session_token = client_data["session_token"]
		var character_class = client_data["character_class"]

		# Validate the session token
		if not user_session_manager.validate_session_token(peer_id, session_token):
			GlobalManager.DebugPrint.debug_error("Invalid session token for peer: " + str(peer_id), self)
			emit_signal("character_selection_failed", "Invalid session token")
			return

		GlobalManager.DebugPrint.debug_info("Session token validated for peer_id: " + str(peer_id), self)
		GlobalManager.DebugPrint.debug_info("Character class received for selection: " + str(character_class), self)

		# Hole die Character ID basierend auf der Klasse
		var character_id = user_session_manager.get_character_id_by_class(peer_id, character_class)
		var auth_token = user_session_manager.get_auth_token_for_peer(peer_id)
		
		if character_id == "":
			GlobalManager.DebugPrint.debug_error("Character ID not found for class: " + str(character_class), self)
			emit_signal("character_selection_failed", "Character ID not found for class")
			return

		# Fetch character data from backend using the retrieved character ID
		fetch_characters_from_backend(auth_token, character_id, peer_id)
	else:
		GlobalManager.DebugPrint.debug_error("Character fetch failed: Missing session_token or character_class", self)
		emit_signal("character_selection_failed", "Missing session_token or character_class")

# Function to make a HTTP request to the backend to fetch character data
func fetch_characters_from_backend(token: String, character_id: String, peer_id: int):
	var route_info = backend_routes_manager.get_route("/characters/select")
	
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_warning("Error: No route found for 'characters/select'", self)
		return
	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Authorization: Bearer " + token, "Content-Type: application/json"]  # Add content type
	var body = {
		"character_id": character_id
	}

	# Convert the body Dictionary to a JSON string
	var json_body = JSON.stringify(body)

	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.connect("request_completed", Callable(self, "_on_backend_characters_response").bind(peer_id))
	
	# Send the request with the JSON body
	var err = http_request.request(backend_url, headers, HTTPClient.METHOD_POST, json_body)

	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send request to backend for characters/select, error code: " + str(err), self)

func _on_backend_characters_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var character_data = json.get_data()
			GlobalManager.DebugPrint.debug_info("Characters fetched: " + str(character_data), self)

			var cleaned_character_data = character_data["character"]  # Nur die Charakterdaten
			cleaned_character_data.erase("user")  # Entferne die Benutzerdaten
			cleaned_character_data.erase("id")  # Entferne die Benutzerdaten
			cleaned_character_data.erase("_id")  # Entferne die Benutzerdaten
			
			print("cleaned_character_data: ", cleaned_character_data)
			
			# Add character to manager
			if character_manager:
				character_manager.add_character_to_manager(peer_id, cleaned_character_data)

			# Assign player to instance
			var instance_key = ""
			if instance_manager:
				instance_key = instance_manager.handle_player_character_selected(peer_id, cleaned_character_data)

			# Prepare the response data, including the instance key
			var response_data = {
				"characters": cleaned_character_data,
				"instance_key": instance_key  # Include instance key in the response
			}
			# Send the packet back to the peer (client)
			print("response_data : SELECT", response_data)
			var err = enet_server_manager.send_packet(peer_id, handler_name, response_data)
			if err != OK:
				GlobalManager.DebugPrint.debug_error("Failed to send packet: " + str(err), self)
			else:
				GlobalManager.DebugPrint.debug_info("Character data packet sent successfully to peer: " + str(peer_id) + " with packet: " + str(response_data), self)
			
			# Emit success signal for any further actions
			emit_signal("character_selected_success", peer_id, character_data)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse character data.", self)
			emit_signal("character_selection_failed", "Failed to parse character data")
	else:
		GlobalManager.DebugPrint.debug_error("Backend returned an error: " + str(response_code), self)
		emit_signal("character_selection_failed", "Backend error: " + str(response_code))
