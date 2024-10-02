extends Node

@onready var user_manager = $".."

# Authenticates the user
func authenticate_user(peer_id: int, username: String, password: String):
	# Load the list of users
	var users_list = user_manager.load_users_list()

	# Check if the username exists
	if username in users_list:
		# Find the user ID of the user
		var user_id = user_manager.get_user_id_by_username(username)

		# Load the user data based on the user ID
		var user_data = user_manager.load_user_data(user_id)

		if user_data.size() == 0:
			print("User data not found for: ", username)
			_send_auth_response(peer_id, false, "User data not found")
			return

		print("user_data: ", user_data)
		# Hash the entered password for comparison
		var hashed_input_password = hash_password(password)
		var user_data_password = user_data["password"]

		# Check the password
		if user_data_password == hashed_input_password:
			print("User authenticated successfully: ", username)
			_send_auth_response(peer_id, true, user_data)
		else:
			print("Incorrect password for user: ", username)
			_send_auth_response(peer_id, false, "Incorrect password")
	else:
		# User does not exist, so create them
		print("User does not exist, creating new user: ", username)
		var new_user_data = user_manager.create_user(username, password)
		_send_auth_response(peer_id, true, new_user_data)

# Sends the authentication response to the peer
func _send_auth_response(peer_id: int, success: bool, user_data_or_message):
	var auth_status = "success" if success else "failed"
	var response_data = {
		"type": "user_auth",
		"auth_status": auth_status,
	}

	# If success, include the user data
	if success:
		response_data["user_data"] = user_data_or_message
	else:
		response_data["error_message"] = user_data_or_message  # On failure, this is the error message

	# Send the response to the peer
	user_manager._send_login_success(peer_id, response_data)

# Hash the user's password using SHA-256
func hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hashed_password = ctx.finish()
	return hashed_password.hex_encode()  # Convert to hex string
