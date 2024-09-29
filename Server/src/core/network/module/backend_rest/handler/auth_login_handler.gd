extends Node

var backend_routes_manager = null
var enet_server_manager = null
var channel_manager = null
var packet_manager = null
var user_session_manager = null
var is_initialized = false
var handler_name = "auth_login_handler"
var debug_enabled = true
# Temporary dictionary to store usernames while waiting for backend responses
var pending_logins = {}

func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("auth_login_handler already initialized. Skipping.", self)
		return
	
	GlobalManager.DebugPrint.set_debug_enabled(debug_enabled)
#	GlobalManager.DebugPrint.set_debug_level(GlobalManager.DebugPrint.DebugLevel.WARNING)
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	backend_routes_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_manager", "enet_server_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	is_initialized = true
	GlobalManager.DebugPrint.debug_info("auth_login_handler initialized.", self)

func handle_packet(client_data: Dictionary, peer_id: int):
	GlobalManager.DebugPrint.debug_info("Received data from peer_id: " + str(peer_id) + " | data: " + str(client_data), self)
	var username = client_data.get("username", "")

	GlobalManager.DebugPrint.debug_info("Currently active users: " + str(user_session_manager.users_data), self)

	if user_session_manager.session_lock_handler.is_session_locked(username):
		GlobalManager.DebugPrint.debug_warning("User session already locked for username: " + username, self)
		_send_error_response(peer_id, "User is already logged in.")
		return

	pending_logins[peer_id] = username
	handle_login_request(client_data, peer_id)

# Send error response to client
func _send_error_response(peer_id: int, message: String):
	var error_response = {"status": "error", "message": message}
	var err = enet_server_manager.send_packet(peer_id, handler_name, error_response)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send error response to peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_info("Error response sent to peer_id: " + str(peer_id), self)

func handle_login_request(client_data: Dictionary, peer_id: int):
	var route_info = backend_routes_manager.get_route("/auth/login")
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_error("No route found for '/auth/login'", self)
		return

	_forward_request_to_backend(route_info, client_data, peer_id)

func _forward_request_to_backend(route_info: Dictionary, client_data: Dictionary, peer_id: int) -> void:
	var backend_url = GlobalManager.GlobalConfig.get_backend_url()
	var url = backend_url + route_info.get("path", "")
	var method_string = route_info.get("methods", [])[0].to_upper()
	var method = _get_http_method_constant(method_string)
	var headers = ["Content-Type: application/json"]
	var body_str = JSON.stringify(client_data)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_backend_login_response").bind(peer_id))
	var err = http_request.request(url, headers, method, body_str)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to forward request to backend for '/auth/login', error code: " + str(err), self)

func _get_http_method_constant(method: String) -> int:
	match method:
		"GET":
			return HTTPClient.METHOD_GET
		"POST":
			return HTTPClient.METHOD_POST
		"PUT":
			return HTTPClient.METHOD_PUT
		"DELETE":
			return HTTPClient.METHOD_DELETE
		_:
			GlobalManager.DebugPrint.debug_warning("Unsupported HTTP method: " + method, self)
			return HTTPClient.METHOD_GET

func _on_backend_login_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		if parse_result == OK:
			var response_data = json.get_data()
			var username = pending_logins.get(peer_id, "")
			
			# Generiere einen Session Token (bspw. zufälliger String oder JWT)
			var session_token = generate_session_token(response_data["user_id"])
			
			var client_data = {
				"user_id": response_data["user_id"],
				"session_token": session_token  # Session Token statt Auth Token
			}
			
			# Speichere die Sitzungsdaten
			if user_session_manager:
				var updated_user_data = {
					"user_id": response_data["user_id"],
					"token": response_data["token"],
					"session_token": session_token,
					"username": username
				}
				print(updated_user_data)
				user_session_manager.update_user_data(peer_id, updated_user_data)

			# Sende die Sitzungsdaten an den Client
			var err = enet_server_manager.send_packet(peer_id, handler_name, client_data)
			if err != OK:
				GlobalManager.DebugPrint.debug_error("Failed to send login packet to peer_id: " + str(peer_id), self)
			else:
				GlobalManager.DebugPrint.debug_info("Login packet sent successfully to peer_id: " + str(peer_id), self)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse JSON response from backend.", self)
	else:
		GlobalManager.DebugPrint.debug_error("Backend returned error with response code: " + str(response_code), self)

# Funktion zur Generierung eines Session Tokens
func generate_session_token(user_id: String) -> String:
	# Kombiniere User-ID und die aktuellen Ticks in Millisekunden zu einem String
	var token_source = user_id + str(Time.get_ticks_msec())

	# Erstelle einen HashingContext für MD5
	var context = HashingContext.new()
	context.start(HashingContext.HASH_MD5)

	# Füge den String zum Hash hinzu
	context.update(token_source.to_utf8_buffer())

	# Berechne den MD5-Hash und konvertiere in eine hexadezimale Zeichenkette
	var hash = context.finish()
	return hash.hex_encode()



