# UserCreateHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users_list.json"

# Lädt die Liste der Benutzer
func load_users_list() -> Array:
	if FileAccess.file_exists(users_list_file):
		var file = FileAccess.open(users_list_file, FileAccess.READ)
		var json = JSON.new()  # Erstellt eine Instanz von JSON
		var result = json.parse(file.get_as_text())  # Verwende die Instanz, um das JSON zu parsen
		file.close()
		
		if result.error == OK:
			return result.result  # Zugriff auf das geparste Ergebnis
		else:
			print("Error parsing users list JSON")
			return []
	else:
		return []  # Leere Liste, wenn keine Datei vorhanden

# Speichert die Liste der Benutzernamen
func save_users_list(users_list: Array) -> void:
	var file = FileAccess.open(users_list_file, FileAccess.WRITE)
	file.store_string(JSON.stringify(users_list))
	file.close()

# Erstelle einen neuen Benutzer und füge ihn der Liste hinzu
func create_user(username: String, password: String) -> Dictionary:
	# Lade die Liste der Benutzer
	var users_list = load_users_list()

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

	# Speichere die Benutzerdaten als JSON-String
	var user_file = FileAccess.open(file_path, FileAccess.WRITE)
	if user_file != null:
		user_file.store_string(JSON.stringify(user_data))
		user_file.close()

		# Füge den neuen Benutzer zur Liste hinzu und speichere die Liste
		users_list.append(username)
		save_users_list(users_list)

		print("User created: ", username)
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
