# UserFetchHandler
extends Node

var users_data_dir = "user://data/users/"

@onready var user_list_handler = $"../UserListHandler"



# Lädt Benutzerdaten (z.B. Passwort) für einen bestimmten Benutzer
func load_user_data(user_id: String) -> Dictionary:
	var user_file_path = users_data_dir + user_id + "/user_data.json"
	
	if FileAccess.file_exists(user_file_path):
		var file = FileAccess.open(user_file_path, FileAccess.READ)
		var json = JSON.new()  # Erstelle eine Instanz von JSON
		var error = json.parse(file.get_as_text())  # Parse das JSON und prüfe das Ergebnis
		file.close()
		
		# Prüfe, ob der Parse-Vorgang erfolgreich war
		if error == OK:
			return json.get_data()  # Gibt das geparste Dictionary zurück
		else:
			print("Error parsing user data JSON for user ID: ", user_id)
			return {}  # Gib ein leeres Dictionary zurück im Fehlerfall
	else:
		print("User data file not found for user ID: ", user_id)
		return {}  # Gib ein leeres Dictionary zurück, wenn die Datei nicht existiert

func get_user_id_by_username(username: String) -> String:
	var users_list = user_list_handler.load_users_list()

	# Loop through the user entries and check their structure
	for user_entry in users_list:
		# If the entry is a dictionary, check for username
		if typeof(user_entry) == TYPE_DICTIONARY:
			if user_entry.has("username") and user_entry["username"] == username:
				return user_entry.get("user_id", "")  # Return the user_id if found
		else:
			print("Invalid user entry format: ", user_entry)

	return ""  # Return an empty string if the user is not found



	
# Optional: Kann verwendet werden, um alle Benutzer und deren Daten zu laden
func fetch_all_users() -> Array:
	var users_list = []
	var dir = DirAccess.open(users_data_dir)

	if dir and dir.list_dir_begin() == OK:
		var folder_name = dir.get_next()
		while folder_name != "":
			if dir.current_is_dir():  # We are now looking for directories (users)
				var user_data = load_user_data(folder_name)
				if user_data.size() > 0:  # Only append if user data was successfully loaded
					users_list.append(user_data)
			folder_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to access users directory")
	
	return users_list
