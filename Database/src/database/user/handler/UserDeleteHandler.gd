extends Node

@onready var database_list = $"../../../../../Control/MainVBoxContainer/MainHBoxContainer/ListContainer/DatabasePanel/DatabaseList"
@onready var delete_user_button = $"../../../../../Control/MainVBoxContainer/MainHBoxContainer/ControlContainer/DatabasePanel/GridContainer/DeleteUserButton"
@onready var user_list_handler = $"../UserListHandler"

var selected_user_id = null  # To store the selected user ID or reference

# Function to delete the selected user
func delete_user(user_id: String) -> bool:
	var user_directory_path = "user://data/users/" + user_id + "/"
	
	# Delete the user directory and associated data
	var deleted = delete_directory(user_directory_path)
	
	# If deletion was successful, remove the user from the users list
	if deleted:
		print("User deleted successfully: ", user_id)
		user_list_handler.remove_user_from_list(user_id)  # Entferne den Benutzer aus der Benutzernamenliste
		database_list.remove_user_from_list(user_id)  # Remove the user from the list of users
		return true
	else:
		print("Failed to delete user: ", user_id)
		return false
		

	
# Called when an item in the user list is selected
func _on_database_list_item_selected(index):
	# Get the selected user from the list
	var selected_user = database_list.get_item_text(index)
	print("Selected User: ", selected_user)
	
	# Assuming user data is stored in the format "ID: user_id | User: username (Characters: x)"
	var user_info = selected_user.split(" | ")  # Split based on " | "
	if user_info.size() > 1:
		selected_user_id = user_info[0].split(": ")[1]  # Extract the user_id after "ID: "
		print("User ID for deletion: ", selected_user_id)
	else:
		print("Failed to parse selected user data")

# Called when the delete button is pressed
func _on_delete_selected_button_pressed():
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
