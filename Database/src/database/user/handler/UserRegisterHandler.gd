# UserCreateHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users/users_list.json"

@onready var character_creation_handler = $"../../../Character/CharacterManager/CharacterCreationHandler"
@onready var user_list_handler = $"../UserListHandler"
@onready var user_fetch_handler = $"../UserFetchHandler"
@onready var database_list = $"../../../../../Control/MainVBoxContainer/MainHBoxContainer/ListContainer/DatabasePanel/DatabaseList"

# Erstelle eine eindeutige ID für den Benutzer
func create_unique_user_id() -> String:
	var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var random_component = ""
	for i in range(6):
		random_component += charset[int(randf() * charset.length())]
	
	# Kombiniere Unix-Zeit mit dem zufälligen String
	var unique_id = str(Time.get_unix_time_from_system()) + "_" + random_component
	return unique_id

# Erstelle einen neuen Benutzer und füge ihn der Liste hinzu
func create_user(username: String, password: String) -> Dictionary:
	var users_list = user_list_handler.load_users_list()

	# Prüfe, ob der Benutzer bereits existiert
	if username in users_list:
		print("User already exists: ", username)
		return {}  # Benutzer existiert bereits
	
	# Erstelle das Benutzerverzeichnis für den spezifischen Benutzer
	var user_id = create_unique_user_id()
	var user_dir = users_data_dir + user_id + "/"
	var character_dir = user_dir + "characters/"

	# Erstelle das Benutzerverzeichnis, falls es nicht existiert
	var dir = DirAccess.open(user_dir)
	if dir == null:
		dir = DirAccess.open("user://")
		dir.make_dir_recursive(user_dir)
		print("Directory created for user: ", user_dir)

	# Erstelle das Charakterverzeichnis für den Benutzer
	dir = DirAccess.open(character_dir)
	if dir == null:
		dir = DirAccess.open("user://")
		dir.make_dir_recursive(character_dir)
		print("Character directory created: ", character_dir)
	
	# Dateipfad für die Benutzerinformationen (JSON-Datei)
	var user_file_path = user_dir + "user_data.json"
	var characters = character_creation_handler.create_characters_for_user(user_id)
	# Hash das Passwort des Benutzers
	print("characterscharacterscharacterscharacters", characters)
	var hashed_password = hash_password(password)
	var user_data = {
		"user_id": user_id,
		"username": username,
		"password": hashed_password,
		"characters": characters,
	}

	# Speichere die Benutzerdaten als JSON-String im Benutzerverzeichnis
	var user_file = FileAccess.open(user_file_path, FileAccess.WRITE)
	if user_file != null:
		user_file.store_string(JSON.stringify(user_data))
		user_file.close()
		
		# Füge den neuen Benutzer zur Benutzerliste hinzu und speichere die Liste
		users_list.append({"username": username, "user_id": user_id})
		user_list_handler.save_users_list(users_list)
		database_list.request_update()
		print("User created: ", username, " with User ID: ", user_id)
		return user_data  # Gib die vollständigen Benutzerdaten zurück
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
