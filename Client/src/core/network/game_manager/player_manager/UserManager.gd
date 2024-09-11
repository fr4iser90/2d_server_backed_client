# res://src/core/network/game_manager/player_manager/user_manager.gd (Client)
extends Node

signal user_data_changed  # Signal to notify when user data is added/updated/removed

var users_data: Dictionary = {}  # Holds all active user data

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

# Funktion zum Setzen der Benutzerposition (falls benötigt)
func set_user_position(user_id: String, position: Vector2):
	if users_data.has(user_id):
		users_data[user_id]["position"] = position
		emit_signal("user_data_changed", user_id, users_data[user_id])
	else:
		print("User not found.")

# Beispiel zur Anzeige der Benutzerinformationen
func print_user_info(user_id: String):
	var user = get_user_data(user_id)
	if not user.empty():
		print("User: ", user["name"], ", Scene: ", user["scene_name"])
	else:
		print("User not found.")
