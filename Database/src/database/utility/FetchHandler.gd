# FetchHandler.gd
extends Node

var users_data_dir = "user://data/users/"
var characters_data_dir = "user://data/characters/"

# Fetch all users from the database
func fetch_all_users() -> Array:
	var users_list = []
	var dir = DirAccess.open(users_data_dir)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".json"):
				var user_data = load_user_data(file_name)
				if user_data.size() > 0:  # Only append if user data was successfully loaded
					users_list.append(user_data)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("Failed to access users directory")
	
	return users_list

# Load user data
func load_user_data(file_name: String) -> Dictionary:
	var file_path = users_data_dir + file_name
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())

		if error == OK:  # Check if the parsing was successful
			file.close()
			return json.get_data()  # Get the parsed dictionary data
		else:
			print("Failed to parse user data for: ", file_name)
			file.close()
	return {}

# Fetch all characters for a specific user
func fetch_user_characters(user_data: Dictionary) -> Array:
	var character_ids = user_data["characters"]
	var characters = []
	print("character_id", character_ids )
	
	for character_entry in character_ids:
		# Extract the character ID from the dictionary
		var character_id = character_entry.get("id", "")
		if character_id != "":
			var character_data = load_character_data(character_id)
			if character_data.size() > 0:
				characters.append(character_data)
	
	return characters


# Load character data by ID
func load_character_data(character_id: String) -> Dictionary:
	var file_path = characters_data_dir + character_id + ".json"
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
