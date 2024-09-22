# res://src/database/user/handler/UserTokenHandler.gd
extends Node

# Handle token request
func handle_token_request(client_id, data):
	var token = data.get("token", "")
	
	if validate_token(token):
		send_success_response(client_id, {"message": "Token valid"})
	else:
		send_error_response(client_id, "Invalid token")

# Generate a new token
func generate_token() -> String:
	# Placeholder logic for token generation
	return "generated_token"

# Validate the token
func validate_token(token: String) -> bool:
	# Placeholder logic for token validation
	return token == "valid_token"

# Send success response to the client
func send_success_response(client_id, response_data):
	var json = JSON.stringify(response_data)
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())

# Send error response to the client
func send_error_response(client_id, error_message):
	var json = JSON.stringify({"error": error_message})
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())
