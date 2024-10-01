# Source/Database/User/Handler/UserLoginHandler.gd
extends Node

@onready var user_manager = $".."


		
func authenticate_user(peer_id: int, username: String, password: String):
	# Lädt die Liste der Benutzer
	var users_list = user_manager.load_users_list()

	# Überprüfe, ob der Benutzer bereits existiert
	if username in users_list:
		# Lade die Benutzerdaten
		var user_data = user_manager.load_user_data(username)
		
		if user_data == null:
			print("User data not found for: ", username)
			user_manager._send_login_error(peer_id, "User data not found")
			return
		
		# Hash das eingegebene Passwort für den Vergleich
		var hashed_input_password = hash_password(password)
		
		# Überprüfe das Passwort
		if user_data["password"] == hashed_input_password:
			print("User authenticated successfully: ", username)
			print("user_data:", user_data)
		
			user_manager._send_login_success(peer_id, user_data)
		else:
			print("Incorrect password for user: ", username)
			user_manager._send_login_error(peer_id, "Incorrect password")
	else:
		# Benutzer existiert nicht, also erstelle ihn
		print("User does not exist, creating new user: ", username)
		var new_user_data = user_manager.create_user(username, password)
		print("User created: ", new_user_data)
		var user_data = new_user_data.erase("characters")
		user_manager._send_login_success(peer_id, user_data)

# Hash the user's password using SHA-256
func hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hashed_password = ctx.finish()
	return hashed_password.hex_encode()  # Convert to hex string
