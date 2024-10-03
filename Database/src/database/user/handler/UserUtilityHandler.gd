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
			var users_list = json.get_data()
			print("Loaded users list: ", users_list)  # Debug-Ausgabe
			return users_list  # The list should contain dictionaries with "username" and "user_id"
		else:
			print("Error parsing users list JSON")
			return []
	else:
		print("Users list file not found")
		return []  # Leere Liste, wenn keine Datei vorhanden

# Speichert die Liste der Benutzernamen in eine Datei
func save_users_list(users_list: Array) -> void:
	var file = FileAccess.open(users_list_file, FileAccess.WRITE)
	file.store_string(JSON.stringify(users_list))
	file.close()
	print("Users list saved successfully")

# Entfernt einen Benutzer aus der Liste und speichert die aktualisierte Liste
func remove_user_from_list(user_id: String) -> void:
	var users_list = load_users_list()

	# Suche nach dem Benutzer mit der entsprechenden ID und entferne ihn
	for i in range(users_list.size()):
		var user_entry = users_list[i]
		if user_entry.has("user_id") and user_entry["user_id"] == user_id:
			users_list.remove_at(i)
			print("User removed from list: ", user_id)
			break

	# Speichere die aktualisierte Liste
	save_users_list(users_list)
