# res://src/core/network/game_manager/player_manager/user_manager.gd (Client)
extends Node

signal user_data_changed  # Signal to notify when user data is added/updated/removed

var users_data: Dictionary = {}  # Holds all active user data
# User-specific session data
var user_id: String = ""
var auth_token: String = ""
var selected_character_id: String = ""
var server_ip: String = ""
var server_port: int = 9997

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	is_initialized = true

# Funktion zum Hinzufügen des Benutzer- oder Charakterdaten
func add_user(character_data: Dictionary):
	var user_id = character_data.get("user", {}).get("_id", "")
	
	if user_id == "":
		print("Error: No valid user ID found.")
		return
	
	users_data[user_id] = character_data
	print("User added: ", character_data.get("name", "Unknown"))
	
	# Signal senden, dass die Daten aktualisiert wurden
	emit_signal("user_data_changed", user_id, users_data[user_id])

# Funktion zum Aktualisieren von Charakterdaten
func update_user(user_id: String, character_data: Dictionary):
	if users_data.has(user_id):
		users_data[user_id] = character_data
		emit_signal("user_data_changed", user_id, character_data)
		print("User data updated for: ", user_id)
	else:
		print("User not found, adding new user.")
		add_user(character_data)

# Funktion zum Abrufen von Benutzer- oder Charakterdaten
func get_user_data(user_id: String) -> Dictionary:
	return users_data.get(user_id, {})

# Beispiel zur Anzeige der Benutzerinformationen
func print_user_info(user_id: String):
	var user = get_user_data(user_id)
	if not user.empty():
		print("User: ", user["name"], ", Scene: ", user["scene_name"])
	else:
		print("User not found.")
# Adding user session data
func set_user_session(user_data: Dictionary):
	user_id = user_data.get("user_id", "")
	auth_token = user_data.get("auth_token", "")
	selected_character_id = user_data.get("character_id", "")
	emit_signal("user_data_changed", user_id, user_data)
	
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
	
# Function to set the user ID
func set_user_id(new_user_id: String):
	user_id = new_user_id
func get_user_id() -> String:
	return user_id
	
# Function to set the auth token
func set_auth_token(new_auth_token: String):
	auth_token = new_auth_token
func get_auth_token() -> String:
	return auth_token
	
# Function to set the selected character ID
func set_selected_character_id(new_character_id: String):
	selected_character_id = new_character_id
func get_selected_character_id() -> String:
	return selected_character_id
