extends Node

@onready var user_manager = $".."
@onready var user_token_handler = $"../UserTokenHandler"

# Authenticates the user
func authenticate_user(peer_id: int, username: String, password: String):
	# Load the list of users
	var users_list = user_manager.load_users_list()

	# Check if the username exists in the list
	var user_id = user_manager.get_user_id_by_username(username)

	if user_id != "":  # If a user_id is found, the user exists
		# Load the user data based on the user ID
		var user_data = user_manager.load_user_data(user_id)

		if user_data.size() == 0:
			print("User data not found for: ", username)
			_send_auth_response(peer_id, false, username, "User not found", user_id)
			return

		print("user_data: ", user_data)
		# Hash the entered password for comparison
		var hashed_input_password = hash_password(password)
		var user_data_password = user_data["password"]

		# Check the password
		if user_data_password == hashed_input_password:
			# Generate a session token
			var database_session_token = user_token_handler.generate_database_session_token()
			
			print("User authenticated successfully: ", username)
			_send_auth_response(peer_id, true, database_session_token, username, user_id)
		else:
			print("Incorrect password for user: ", username)
			_send_auth_response(peer_id, false, username, "Incorrect password", user_id)
	else:
		# User does not exist, create a new user
		print("User does not exist, creating new user: ", username)
		var new_user_data = user_manager.create_user(username, password)
		var database_session_token = user_token_handler.generate_database_session_token()
		_send_auth_response(peer_id, true, database_session_token, username, new_user_data["user_id"])


# Sends the authentication response to the peer
func _send_auth_response(peer_id: int, success: bool, token_or_message: String, username: String, user_id = ""):
	var auth_status = "success" if success else "failed"
	var response_data = {
		"type": "user_auth",
		"auth_status": auth_status,
	}

	# If success, include the database_session_token, user_id, and username
	if success:
		response_data["database_session_token"] = token_or_message
		response_data["user_id"] = user_id
		response_data["username"] = username
	else:
		response_data["error_message"] = token_or_message  # On failure, this is the error message

	# Send the response to the peer
	user_manager._send_login_success(peer_id, response_data)



# Hash the user's password using SHA-256
func hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hashed_password = ctx.finish()
	return hashed_password.hex_encode()  # Convert to hex string
