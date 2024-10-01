# DatabaseUserLoginHandler REST
extends Node

signal backend_login_processed(peer_id, processed_data)

var network_endpoint_manager = null
var user_session_manager = null
var is_initialized = false

func initialize():
	if is_initialized:
		return
	network_endpoint_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_endpoint_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	is_initialized = true

# This function processes the login and returns the result back to the client handler
func process_login(client_data: Dictionary, peer_id: int) -> void:
	var route_info = network_endpoint_manager.get_route("/auth/login")
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_error("No route found for '/auth/login'", self)
		return

	var backend_url = GlobalManager.GlobalConfig.get_backend_url() + route_info.get("path", "")
	var headers = ["Content-Type: application/json"]
	var body_str = JSON.stringify(client_data)

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_backend_login_response").bind(peer_id))
	var err = http_request.request(backend_url, headers, HTTPClient.METHOD_POST, body_str)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send request to backend for login", self)

func _on_backend_login_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)

		if parse_result == OK:
			var response_data = json.get_data()
			var username = response_data.get("username", "")
			var session_token = generate_session_token(response_data["user_id"])

			var processed_data = {
				"user_id": response_data["user_id"],
				"session_token": session_token
			}

			# Store user session
			var updated_user_data = {
				"user_id": response_data["user_id"],
				"token": response_data["token"],
				"session_token": session_token,
				"username": username
			}
			user_session_manager.update_user_data(peer_id, updated_user_data)

			# Return the data to the client handler (via signal or direct function call)
			emit_signal("backend_login_processed", peer_id, processed_data)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse backend response", self)
	else:
		GlobalManager.DebugPrint.debug_error("Backend login failed with response code: " + str(response_code), self)

func generate_session_token(user_id: String) -> String:
	var token_source = user_id + str(Time.get_ticks_msec())
	var context = HashingContext.new()
	context.start(HashingContext.HASH_MD5)
	context.update(token_source.to_utf8_buffer())
	return context.finish().hex_encode()
