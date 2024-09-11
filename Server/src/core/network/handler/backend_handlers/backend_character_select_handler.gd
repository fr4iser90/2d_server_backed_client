# res://src/core/network/backend/backend_handlers/handle_backend_character_select.gd (Server)
extends Node

signal character_selected_success(peer_id: int, character_data: Dictionary)
signal character_selection_failed(reason: String)

var backend_routes_manager
var enet_server_manager
var user_session_manager
var handler_name = "backend_character_select_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	backend_routes_manager = GlobalManager.GlobalNodeManager.get_node_from_config("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_manager", "enet_server_manager")
	user_session_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_meta_manager", "user_session_manager")
	is_initialized = true


func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("token") and client_data.has("character_id"):
		var token = client_data["token"]
		var character_id = client_data["character_id"]
		print("Token received for character fetch: ", token)
		print("Character ID received for selection: ", character_id)
		# Rufe Charakterdaten vom Backend ab
		fetch_characters_from_backend(token, character_id, peer_id)
	else:
		print("Character fetch failed: Missing token or character_id")
		emit_signal("character_selection_failed", "Missing token or character_id")
		
# Funktion, die einen HTTP-Request an das Backend stellt, um die Charakterdaten zu holen
func fetch_characters_from_backend(token: String, character_id: String, peer_id: int):
	var route_info = backend_routes_manager.get_route("/characters/select")
	
	if route_info.size() == 0:
		print("Error: No route found for 'characters/select'")
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
		print("Failed to send request to backend for characters/select, error code: ", err)

		
func _on_backend_characters_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		print("Request successful, response: ", response_text)
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var character_data = json.get_data()
			print("Characters fetched: ", character_data)

			var character_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "character_manager")
			if character_manager:
				character_manager.add_character_to_manager(peer_id, {"selected_character": character_data})
				
			var instance_manager = GlobalManager.GlobalNodeManager.get_node_from_config("world_manager", "instance_manager")
			if instance_manager:
				# Dynamischer Aufruf der Charakterauswahl und Spawnen des Spielers
				instance_manager.handle_player_character_selected(peer_id, character_data["character"])
			if user_session_manager:
				user_session_manager.attach_character_to_user(peer_id)
			# Erstelle das Dictionary für die Antwortdaten
			var response_data = {
				"characters": character_data
			}

			# Sende das Paket an den Peer über den enet_server_manager
			var err = enet_server_manager.send_packet(peer_id, handler_name, response_data)
			if err != OK:
				print("Failed to send packet:", err)
			else:
				print("Character data packet sent successfully to peer: ", peer_id)
			# Emit success signal to trigger spawning and world setup
			emit_signal("character_selected_success", peer_id, character_data)
		else:
			print("Failed to parse character data.")
			emit_signal("character_selection_failed", "Failed to parse character data")
	else:
		print("Backend returned an error: ", response_code)
		emit_signal("character_selection_failed", "Backend error: " + str(response_code))
