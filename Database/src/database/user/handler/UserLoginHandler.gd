# Source/Database/User/Handler/UserLoginHandler.gd
extends Node

# Handle login request
func handle_login_request(client_id, data):
	var username = data.get("username", "")
	var password = data.get("password", "")

	# Simulate checking against the user data
	var user_model = get_node("/root/Data/Users/UserModel")
	var user = user_model.find_user(username, password)
	
	if user != null:
		send_success_response(client_id, {"message": "Login successful", "user_id": user.user_id})
	else:
		send_error_response(client_id, "Invalid credentials")

# Send success response to the client
func send_success_response(client_id, response_data):
	var json = JSON.stringify(response_data)
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())

# Send error response to the client
func send_error_response(client_id, error_message):
	var json = JSON.stringify({"error": error_message})
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())

