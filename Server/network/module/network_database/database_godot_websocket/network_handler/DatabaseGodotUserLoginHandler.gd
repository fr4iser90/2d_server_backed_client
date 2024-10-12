# DatabaseUserLoginHandler GODOT
extends Node

signal backend_login_processed(peer_id, processed_data)
signal login_request_sent

var user_session_manager
var websocket_multiplayer_manager
var is_initialized = false
var stored_peer_id  # Variable to store the ENet peer_id

func initialize():
	if is_initialized:
		return
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	websocket_multiplayer_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkMiddlewareManager")
	is_initialized = true
	
# This function sends the login data to the server over WebSocket
func process_login(client_data: Dictionary, peer_id: int) -> void:
	stored_peer_id = peer_id  # Store the ENet peer_id for later use
	var websocket_peer = websocket_multiplayer_manager.get_websocket_peer()
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		var login_packet = {
			"type": "user",  # Specify packet type for login
			"action": "authenticate",
			"username": client_data.get("username", ""),
			"password": client_data.get("password", "")
		}
		var json_str = JSON.stringify(login_packet)
		websocket_peer.set_target_peer(1)  # Assuming 1 is the server ID
		websocket_peer.put_packet(json_str.to_utf8_buffer())

		emit_signal("login_request_sent")
	else:
		print("WebSocket is not connected, unable to send login data")

func handle_user_auth(packet: Dictionary):
	# Directly use the packet as it's already a Dictionary
	var response_data = packet
	
	# Check if the packet is of type 'user_auth'
	if response_data.has("type") and response_data["type"] == "user_auth":
		var auth_status = response_data.get("auth_status", "")
		if auth_status == "success":
			# Parse response_data (assuming it's already a Dictionary and no need to call json.get_data())
			var username = response_data.get("username", "")
			var server_session_token = generate_session_token(response_data["user_id"])

			var processed_data = {
				"user_id": response_data["user_id"],
				"server_session_token": server_session_token
			}

			# Store user session
			var updated_user_data = {
				"user_id": response_data["user_id"],
				"database_session_token": response_data["database_session_token"],
				"server_session_token": server_session_token,
				"username": username
			}
			
			user_session_manager.update_user_data(stored_peer_id, updated_user_data)

			# Return the data to the client handler (via signal or direct function call)
			emit_signal("backend_login_processed", stored_peer_id, processed_data)
		else:
			# Authentication failed
			var error_message = response_data.get("error_message", "Unknown error")
			print("Login failed: ", error_message)
			emit_signal("login_response_received", false, {})
	else:
		print("Unexpected packet type or missing 'user_auth' field in response")

func generate_session_token(user_id: String) -> String:
	var token_source = user_id + str(Time.get_ticks_msec())
	var context = HashingContext.new()
	context.start(HashingContext.HASH_MD5)
	context.update(token_source.to_utf8_buffer())
	return context.finish().hex_encode()
