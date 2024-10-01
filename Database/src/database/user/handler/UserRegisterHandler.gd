# UserCreateHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users_list.json"

@onready var character_creation_handler = $"../../../Character/CharacterManager/CharacterCreationHandler"
@onready var user_utility_handler = $"../UserUtilityHandler"

# Erstelle einen neuen Benutzer und füge ihn der Liste hinzu
func create_user(username: String, password: String) -> Dictionary:
	# Lade die Liste der Benutzer
	var users_list = user_utility_handler.load_users_list()

	# Check if the user already exists in the list
	if username in users_list:
		print("User already exists: ", username)
		return {}  # Benutzer existiert bereits
	
	# Erstelle das Benutzerverzeichnis, falls es nicht existiert
	var dir = DirAccess.open(users_data_dir)
	if dir == null:
		dir = DirAccess.open("user://")
		dir.make_dir_recursive(users_data_dir)
		print("Directory created: ", users_data_dir)
		
	var file_path = users_data_dir + username + ".json"
	
	# Hash das Passwort des Benutzers
	var hashed_password = hash_password(password)
	var user_data = {
		"username": username,
		"password": hashed_password,
		"characters": []
	}

	# Erstelle einen Charakter für den Benutzer
	var character_data = character_creation_handler.create_character_for_user(username)  # Assuming this creates a default character
	var character_id = character_creation_handler.create_unique_character_id()
	
	# Füge den Charakter zur Liste der Benutzer hinzu
	user_data["characters"].append({
		"id": character_id,
		"data": character_data
	})

	# Speichere die Benutzerdaten als JSON-String
	var user_file = FileAccess.open(file_path, FileAccess.WRITE)
	if user_file != null:
		user_file.store_string(JSON.stringify(user_data))
		user_file.close()

		# Füge den neuen Benutzer zur Liste hinzu und speichere die Liste
		users_list.append(username)
		user_utility_handler.save_users_list(users_list)

		print("User created with character: ", username)
		return user_data  # Gib die vollständigen Benutzerdaten und Charakterdaten zurück
	else:
		print("Failed to create user file for: ", username)
		return {}

# Passwort mit SHA-256 hashen
func hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hashed_password = ctx.finish()
	return hashed_password.hex_encode()  # In Hex-String umwandeln
