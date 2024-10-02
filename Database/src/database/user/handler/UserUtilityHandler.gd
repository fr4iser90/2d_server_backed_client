# UserListHandler.gd
extends Node

var users_list_file = "user://data/users/users_list.json"

# Lädt die Liste der Benutzernamen aus einer Datei
func load_users_list() -> Array:
	if FileAccess.file_exists(users_list_file):
		var file = FileAccess.open(users_list_file, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		file.close()
		
		if error == OK:
			return json.get_data()  # The list should contain dictionaries with "username" and "user_id"
		else:
			print("Error parsing users list JSON")
			return []
	else:
		return []  # Leere Liste, wenn keine Datei vorhanden

# Speichert die Liste der Benutzernamen in eine Datei
func save_users_list(users_list: Array) -> void:
	var file = FileAccess.open(users_list_file, FileAccess.WRITE)
	file.store_string(JSON.stringify(users_list))
	file.close()
	print("Users list saved successfully")
