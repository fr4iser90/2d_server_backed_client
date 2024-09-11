# res://src/core/network/backend/backend_handlers/backend_character_handler.gd (Server)
extends Node

var backend_routes_manager
var enet_server_manager 
var handler_name = "backend_character_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	backend_routes_manager = GlobalManager.GlobalNodeManager.get_node_from_config("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_manager", "enet_server_manager")
	is_initialized = true

func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("token"):
		var token = client_data["token"]
		#print("Token received for character fetch: ", token)

		# Rufe Charakterdaten vom Backend ab
		fetch_characters_from_backend(token, peer_id)
	else:
		print("Character fetch failed: Missing token")

# Funktion, die einen HTTP-Request an das Backend stellt, um die Charakterdaten zu holen
func fetch_characters_from_backend(token: String, peer_id: int):
	var route_info = backend_routes_manager.get_route("/characters")

	if route_info.size() == 0:
		print("Error: No route found for 'characters'")
		return

	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Authorization: Bearer " + token]

	var http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.connect("request_completed", Callable(self, "_on_backend_characters_response").bind(peer_id))
	var err = http_request.request(backend_url, headers, HTTPClient.METHOD_GET)

	if err != OK:
		print("Failed to send request to backend for characters, error code: ", err)
		
func _on_backend_characters_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var characters = json.get_data()
			# Erstelle das Dictionary für die Antwortdaten
			var response_data = {
				"characters": characters
			}
			# Sende das Paket an den Peer über den enet_server_manager
			var err = enet_server_manager.send_packet(peer_id, handler_name, response_data)
			if err != OK:
				print("Failed to send packet:", err)
			else:
				pass
		else:
			print("Failed to parse character data.")
	else:
		print("Backend returned an error: ", response_code)
