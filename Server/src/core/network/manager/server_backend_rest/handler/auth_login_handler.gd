# res://src/core/network/backend/backend_handlers/handle_backend_login.gd (Server)
extends Node

var backend_routes_manager = null
var enet_server_manager = null
var channel_manager = null
var packet_manager = null
var user_session_manager = null
var is_initialized = false
var handler_name = "auth_login_handler"

func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	backend_routes_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "backend_routes_manager")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_manager", "enet_server_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	is_initialized = true

func handle_packet(client_data: Dictionary, peer_id: int):
	# Add or update the user with peer_id and username at the login point
	if user_session_manager:
		# Store the username from the client_data packet (if provided)
		var initial_user_data = {"username": client_data.get("username", ""), "peer_id": peer_id}
		user_session_manager.add_user_to_manager(peer_id, initial_user_data)
	# Now forward the request to the backend to complete login
	handle_login_request(client_data, peer_id)


func handle_login_request(client_data: Dictionary, peer_id: int):
	# Hole die Route für den Login-Endpunkt dynamisch
	var route_info = backend_routes_manager.get_route("/auth/login")  # "login" ist der Name, unter dem die Route abgefragt wird
	if route_info.size() == 0:
		print("Error: No route found for '/auth/login'")
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
		print("Failed to forward request to backend, error code: ", err)

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
			print("Unsupported HTTP method: ", method)
			return HTTPClient.METHOD_GET

func _on_backend_login_response(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		if parse_result == OK:
			var response_data = json.get_data()
			var client_data = {
				"user_id": response_data["user_id"],
				"token": response_data["token"]
			}
			if user_session_manager:
				# Add or update the user with user_id and token
				var updated_user_data = {
					"user_id": response_data["user_id"],
					"token": response_data["token"]
				}
				user_session_manager.update_user_data(peer_id, updated_user_data)
			# send packet to peer id
			var err = enet_server_manager.send_packet(peer_id, handler_name, client_data)
			if err != OK:
				print("Failed to send packet:", err)
			else:
				print("Login packet sent successfully")
			#print("Data sent to client with peer_id: ", peer_id)
		else:
			print("Failed to parse JSON response.")
	else:
		print("Request failed with response code: ", response_code)
