# UserFetchHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users_list.json"

# Lädt die Liste der Benutzernamen aus der JSON-Datei
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

# Lädt Benutzerdaten (z.B. Passwort) für einen bestimmten Benutzer
func load_user_data(username: String) -> Dictionary:
	var user_file_path = users_data_dir + username + "/user_data.json"
	
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

# Optional: Kann verwendet werden, um alle Benutzer und deren Daten zu laden
func fetch_all_users() -> Array:
	var users_list = load_users_list()
	var all_users_data = []
	for user in users_list:
		var user_data = load_user_data(user)
		if user_data.size() > 0:
			all_users_data.append(user_data)
	return all_users_data
