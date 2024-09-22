# UserModel.gd
extends Node  # You can also use `extends Node` if necessary for your project

class_name UserModel

# Define user attributes
var username: String = ""
var password: String = ""
var character_slots: int = 3
var characters: Array = []
var shared_stash: Dictionary = {}
var guilds: Array = []
var selected_character: Dictionary = {}
var created_at: String = ""

# Save user data to a JSON file
func save_user_data(filepath: String):
	var user_data = {
		"username": username,
		"password": password,
		"character_slots": character_slots,
		"characters": characters,
		"shared_stash": shared_stash,
		"guilds": guilds,
		"selected_character": selected_character,
		"created_at": created_at
	}
	var json = JSON.new()
	var json_string = json.stringify(user_data)

	if json_string != null:
		var file = FileAccess.open(filepath, FileAccess.WRITE)
		if file:
			file.store_string(json_string)
			file.close()
			print("User data saved successfully")
		else:
			print("Error opening file for writing")
	else:
		print("Error converting user data to JSON")

# Load user data from a JSON file
func load_user_data(filepath: String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		var json = JSON.new()
		var err = json.parse(json_data)
		if err == OK:
			var user_data = json.get_data()
			username = user_data["username"]
			password = user_data["password"]
			character_slots = user_data["character_slots"]
			characters = user_data["characters"]
			shared_stash = user_data["shared_stash"]
			guilds = user_data["guilds"]
			selected_character = user_data["selected_character"]
			created_at = user_data["created_at"]
			print("User data loaded successfully")
		else:
			print("Error parsing user data:", err)
		file.close()
	else:
		print("Error opening file for reading")
