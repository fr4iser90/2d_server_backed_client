extends Node

var backend_routes_manager
var enet_server_manager
var handler_name = "char_fetch_handler"
var debug_enabled = false
var is_initialized = false

func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("handle_backend_login already initialized. Skipping.", self)
		return
	
	# Setze den Debug-Modus für dieses Skript
	GlobalManager.DebugPrint.set_debug_enabled(debug_enabled)
	# Optional: Setze das Debug-Level für dieses Modul
	GlobalManager.DebugPrint.set_debug_level(GlobalManager.DebugPrint.DebugLevel.WARNING)

	# Initialisiere die Manager
	backend_routes_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_manager", "enet_server_manager")
	is_initialized = true

func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("token"):
		var token = client_data["token"]
		GlobalManager.DebugPrint.debug_info("Token received for character fetch: " + token, self)

		# Fetch character data from the backend
		fetch_characters_from_backend(token, peer_id)
	else:
		GlobalManager.DebugPrint.debug_error("Character fetch failed: Missing token", self)

# Function to make an HTTP request to the backend to fetch character data
func fetch_characters_from_backend(token: String, peer_id: int):
	var route_info = backend_routes_manager.get_route("/characters")

	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_warning("Error: No route found for 'characters'", self)
		return

	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Authorization: Bearer " + token]

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
			# Create the response data dictionary
			var response_data = {
				"characters": characters
			}
			# Send the packet to the peer via the enet_server_manager
			var err = enet_server_manager.send_packet(peer_id, handler_name, response_data)
			if err != OK:
				GlobalManager.DebugPrint.debug_error("Failed to send packet: " + str(err), self)
			else:
				GlobalManager.DebugPrint.debug_info("Characters sent successfully to peer: " + str(peer_id), self)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse character data.", self)
	else:
		GlobalManager.DebugPrint.debug_error("Backend returned an error: " + str(response_code), self)
