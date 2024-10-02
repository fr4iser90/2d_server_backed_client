extends Node


@onready var database_list = $"../../../../Control/MainVBoxContainer/MainHBoxContainer/ListContainer/DatabasePanel/DatabaseList"
@onready var delete_selected_button = $"../../../../Control/MainVBoxContainer/MainHBoxContainer/ControlContainer/DatabasePanel/GridContainer/DeleteSelectedButton"
@onready var delete_database = $"../../../../Control/MainVBoxContainer/MainHBoxContainer/ControlContainer/DatabasePanel/GridContainer/DeleteDATABASE"

var selected_user_id = null  # To store the selected user ID or reference

# Function to delete the selected user
func delete_user(user_id: String) -> bool:
	var user_directory_path = "user://data/users/" + user_id + "/"  # Updated to point to directory, not a file
	return delete_directory(user_directory_path)


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

# Called when the delete database button is pressed
func _on_delete_database_button_pressed():
	var users_directory_path = "user://data/users"
	if delete_directory(users_directory_path):
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
		if dir.remove(directory_path) == OK:
			print("Directory deleted successfully: ", directory_path)
			return true
		else:
			print("Failed to delete directory: ", directory_path)
			return false
	else:
		print("Directory does not exist or failed to list: ", directory_path)
		return false
