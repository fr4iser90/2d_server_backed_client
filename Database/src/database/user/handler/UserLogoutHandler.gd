# res://src/database/user/handler/UserLogoutHandler.gd
extends Node

# Handle logout request
func handle_logout_request(client_id, data):
	print("User logged out successfully")
	send_success_response(client_id, {"message": "User logged out successfully"})

# Send success response to the client
func send_success_response(client_id, response_data):
	var json = JSON.stringify(response_data)
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())

# Send error response to the client
func send_error_response(client_id, error_message):
	var json = JSON.stringify({"error": error_message})
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())
