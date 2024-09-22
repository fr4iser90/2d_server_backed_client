extends Node

var users_data_dir = "res://data/users/"

# Handle registration request
func handle_register_request(client_id, data):
	var username = data.get("username", "")
	var password = data.get("password", "")

	if register_user(username, password):
		send_success_response(client_id, {"message": "User registered successfully"})
	else:
		send_error_response(client_id, "User already exists")

# Register a new user
func register_user(username: String, password: String) -> bool:
	var file_path = users_data_dir + username + ".json"
	
	# Check if user already exists
	var user_file = FileAccess.open(file_path, FileAccess.READ)
	if user_file != null:
		return false  # User already exists
	
	# Hash the user's password
	var hashed_password = hash_password(password)
	var user_data = {
		"username": username,
		"password": hashed_password,
		"characters": []
	}
	
	# Save user data as a JSON string
	user_file = FileAccess.open(file_path, FileAccess.WRITE)
	user_file.store_string(JSON.stringify(user_data))
	user_file.close()
	
	return true

# Hash the user's password using SHA-256
func hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hashed_password = ctx.finish()
	return hashed_password.hex_encode()  # Convert to hex string

# Send success response to the client
func send_success_response(client_id, response_data):
	var json = JSON.stringify(response_data)
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())

# Send error response to the client
func send_error_response(client_id, error_message):
	var json = JSON.stringify({"error": error_message})
	get_parent().ws_server.get_peer(client_id).put_packet(json.to_utf8_buffer())


