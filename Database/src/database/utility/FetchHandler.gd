extends Node

var users_data_dir = "user://data/users/"
var characters_data_dir_suffix = "/characters/"

# Fetch all users from the database
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

# Load user data from the user's directory
func load_user_data(username: String) -> Dictionary:
	var file_path = users_data_dir + username + "/user_data.json"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())

		if error == OK:  # Check if the parsing was successful
			file.close()
			return json.get_data()  # Get the parsed dictionary data
		else:
			print("Failed to parse user data for: ", username)
			file.close()
	return {}

# Fetch all characters for a specific user
func fetch_user_characters(user_data: Dictionary) -> Array:
	var character_ids = user_data["characters"]
	var characters = []
	#print("character_id", character_ids)
	
	for character_entry in character_ids:
		# Extract the character ID from the dictionary
		var character_id = character_entry.get("id", "")
		if character_id != "":
			var character_data = load_character_data(user_data["username"], character_id)
			if character_data.size() > 0:
				characters.append(character_data)
	
	return characters

# Load character data by ID for a specific user
func load_character_data(username: String, character_id: String) -> Dictionary:
	var file_path = users_data_dir + username + characters_data_dir_suffix + character_id + ".json"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())

		if error == OK:
			file.close()
			return json.get_data()
		else:
			print("Failed to parse character data for: ", character_id)
			file.close()
	return {}
