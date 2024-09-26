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
	user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	is_initialized = true

func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("token") and client_data.has("character_id"):
		var token = client_data["token"]
		var character_id = client_data["character_id"]
		GlobalManager.DebugPrint.debug_info("Token received for character fetch: " + str(token), self)
		GlobalManager.DebugPrint.debug_info("Character ID received for selection: " + str(character_id), self)
		# Fetch character data from the backend
		fetch_characters_from_backend(token, character_id, peer_id)
	else:
		GlobalManager.DebugPrint.debug_error("Character fetch failed: Missing token or character_id", self)
		emit_signal("character_selection_failed", "Missing token or character_id")

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
			print("response_data :", response_data)
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
