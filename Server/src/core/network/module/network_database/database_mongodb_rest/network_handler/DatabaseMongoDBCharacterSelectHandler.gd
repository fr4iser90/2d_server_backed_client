# DatabaseMongoDBCharacterSelectHandler.gd
extends Node

signal character_selected_success(peer_id: int, character_data: Dictionary)
signal character_selection_failed(reason: String)

var backend_routes_manager
var user_session_manager
var character_manager
var instance_manager
var is_initialized = false

func initialize():
	if is_initialized:
		return
	backend_routes_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_endpoint_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	is_initialized = true

# Process character selection, fetch data from backend, and return result to the client handler
func process_character_selection(peer_id: int, character_class: String):
	var character_id = user_session_manager.get_character_id_by_class(peer_id, character_class)
	var database_session_token = user_session_manager.get_database_session_token_for_peer(peer_id)
	
	if character_id == "":
		GlobalManager.DebugPrint.debug_error("Character ID not found for class: " + str(character_class), self)
		emit_signal("character_selection_failed", "Character ID not found for class")
		return

	# Fetch character data from backend
	fetch_characters_from_backend(database_session_token, character_id, peer_id)

# Function to make HTTP request to fetch character data from backend
func fetch_characters_from_backend(token: String, character_id: String, peer_id: int):
	var route_info = backend_routes_manager.get_route("/characters/select")
	
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_warning("Error: No route found for 'characters/select'", self)
		return

	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Authorization: Bearer " + token, "Content-Type: application/json"]
	var body = {
		"character_id": character_id
	}
	var json_body = JSON.stringify(body)

	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.connect("request_completed", Callable(self, "_on_backend_characters_response").bind(peer_id))
	var err = http_request.request(backend_url, headers, HTTPClient.METHOD_POST, json_body)

	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send request to backend for characters/select", self)

# Handle the backend response and clean character data
func _on_backend_characters_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var character_data = json.get_data()
			var cleaned_character_data = clean_character_data(character_data["character"])

			# Add character to manager
			character_manager.add_character_to_manager(peer_id, cleaned_character_data)

			# Handle instance assignment
			var instance_key = instance_manager.handle_player_character_selected(peer_id, cleaned_character_data)

			# Prepare data to send back to client
			var response_data = {
				"characters": cleaned_character_data,
				"instance_key": instance_key
			}
			print("response_data REST: ", response_data)
			# Emit success signal
			emit_signal("character_selected_success", peer_id, response_data)
		else:
			emit_signal("character_selection_failed", "Failed to parse character data")
	else:
		emit_signal("character_selection_failed", "Backend error: " + str(response_code))

# Clean character data before sending it to the client
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)
	cleaned_data.erase("user")
	cleaned_data.erase("id")
	cleaned_data.erase("_id")
	return cleaned_data
