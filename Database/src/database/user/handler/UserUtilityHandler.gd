# UserUtilityHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users_list.json"

# Lädt die Liste der Benutzernamen
func load_users_list() -> Array:
	if FileAccess.file_exists(users_list_file):
		var file = FileAccess.open(users_list_file, FileAccess.READ)
		var json = JSON.new()  # Erstellt eine Instanz von JSON
		var error = json.parse(file.get_as_text())  # Parse das JSON und prüfe das Ergebnis
		file.close()
		
		# Prüfe, ob der Parse-Vorgang erfolgreich war
		if error == OK:
			return json.get_data()  # Zugriff auf das geparste Ergebnis
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

# Lädt Benutzerdaten (z.B. Passwort)
func load_user_data(username: String) -> Dictionary:
	var user_file_path = users_data_dir + username + ".json"
	
	if FileAccess.file_exists(user_file_path):
		var file = FileAccess.open(user_file_path, FileAccess.READ)
		var json = JSON.new()  # Erstelle eine Instanz von JSON
		var error = json.parse(file.get_as_text())  # Parse das JSON und prüfe das Ergebnis
		file.close()
		
		# Prüfe, ob der Parse-Vorgang erfolgreich war
		if error == OK:
			return json.get_data()  # Gibt das geparste Dictionary zurück
		else:
			print("Error parsing user data JSON for user: ", username)
			return {}  # Gib ein leeres Dictionary zurück im Fehlerfall
	else:
		return {}  # Gib ein leeres Dictionary zurück, wenn die Datei nicht existiert

