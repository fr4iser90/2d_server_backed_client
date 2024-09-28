# res://src/core/network/game_manager/player_manager/user_manager.gd (Client)
extends Node

signal user_data_changed  # Signal to notify when user data is added/updated/removed

var users_data: Dictionary = {}  # Holds all active user data
var session_token: String = ""  # Holds the session token for the user
var server_ip: String = ""
var server_port: int = 9997

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	is_initialized = true

# Function to add user or character data
func add_user(character_data: Dictionary):
	var user_name = character_data.get("name", "Unknown")

	users_data[user_name] = character_data
	print("User added: ", user_name)
	
	# Signal that the data has been updated
	emit_signal("user_data_changed", user_name, users_data[user_name])

# Function to update character data
func update_user(user_name: String, character_data: Dictionary):
	if users_data.has(user_name):
		users_data[user_name] = character_data
		emit_signal("user_data_changed", user_name, character_data)
		print("User data updated for: ", user_name)
	else:
		print("User not found, adding new user.")
		add_user(character_data)

# Function to retrieve user or character data
func get_user_data(user_name: String) -> Dictionary:
	return users_data.get(user_name, {})

# Example to display user information
func print_user_info(user_name: String):
	var user = get_user_data(user_name)
	if not user.empty():
		print("User: ", user["name"], ", Scene: ", user["scene_name"])
	else:
		print("User not found.")

# Set the user session token
func set_session_token(new_session_token: String):
	session_token = new_session_token
	print("Session token set: ", session_token)

# Get the user session token
func get_session_token() -> String:
	return session_token

# Function to set the server IP
func set_server_ip(new_server_ip: String):
	server_ip = new_server_ip

func get_server_ip() -> String:
	return server_ip
	
# Set and get server port
func set_server_port(new_server_port: int):
	server_port = new_server_port

func get_server_port() -> int:
	return server_port
