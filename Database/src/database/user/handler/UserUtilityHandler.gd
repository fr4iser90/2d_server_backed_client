# UserUtilityHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users_list.json"

@onready var database_list = $"../../../../../Control/MainVBoxContainer/MainHBoxContainer/ListContainer/DatabasePanel/DatabaseList"
@onready var delete_user_button = $"../../../../../Control/MainVBoxContainer/MainHBoxContainer/ControlContainer/DatabasePanel/GridContainer/DeleteUserButton"

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

var selected_user_id = null  # To store the selected user ID or reference

# Function to delete the selected user
func delete_user(user_id: String) -> bool:
	var user_directory_path = "user://data/users/" + user_id + ".json"
	return delete_file(user_directory_path)

# Called when an item in the user list is selected
func _on_database_list_item_selected(index):
	# Get the selected user from the list
	var selected_user = database_list.get_item_text(index)
	print("Selected User: ", selected_user)
	
	# Assuming user data is stored in the format "User: username (Characters: x)"
	var user_info = selected_user.split(" ")
	selected_user_id = user_info[1]  # Assuming the username is the second word
	print("User ID for deletion: ", selected_user_id)

# Called when the delete button is pressed
func _on_delete_user_button_pressed():
	if selected_user_id != null:
		var success = delete_user(selected_user_id)
		if success:
			print("User deleted successfully")
			# Remove the user from the list
			database_list.remove_item(database_list.get_selected_items()[0])
			selected_user_id = null
		else:
			print("Failed to delete user")
	else:
		print("No user selected")


# Delete the file that stores the user data
func delete_file(file_path: String) -> bool:
	var dir = DirAccess.open("user://")
	if dir.file_exists(file_path):
		var err = dir.remove(file_path)
		if err == OK:
			print("File deleted successfully: ", file_path)
			return true
		else:
			print("Failed to delete file: ", file_path)
			return false
	else:
		print("File does not exist: ", file_path)
		return false


func delete_all_users() -> bool:
	var users_directory_path = "user://data/users/"
	return delete_directory(users_directory_path)
	
func _on_delete_database_pressed():
	if delete_all_users():
		print("All users and data deleted successfully.")
		# Optionally clear the user list from the UI
		database_list.clear()
	else:
		print("Failed to delete all user data.")

# Function to recursively delete a directory and its contents
func delete_directory(directory_path: String) -> bool:
	var dir = DirAccess.open(directory_path)
	if dir != null and dir.list_dir_begin() == OK:
		var file_name = dir.get_next()
		while file_name != "":
			var file_path = directory_path + "/" + file_name
			if dir.current_is_dir():  # If it's a subdirectory, delete it recursively
				if not delete_directory(file_path):
					return false
			else:
				# Delete the file
				if dir.remove(file_path) != OK:
					print("Failed to delete file: ", file_path)
					return false
			file_name = dir.get_next()
		dir.list_dir_end()  # End directory listing
		# Finally, remove the directory itself
		var dir_instance = DirAccess.open("user://")  # Create an instance to call remove()
		if dir_instance and dir_instance.remove(directory_path) == OK:
			print("Directory deleted successfully: ", directory_path)
			return true
		else:
			print("Failed to delete directory: ", directory_path)
			return false
	else:
		print("Directory does not exist or failed to list: ", directory_path)
		return false
