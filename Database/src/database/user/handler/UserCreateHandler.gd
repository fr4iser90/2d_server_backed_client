# UserCreateHandler
extends Node

var users_data_dir = "user://data/users/"
var users_list_file = "user://data/users/users_list.json"

@onready var character_creation_handler = $"../../../Character/CharacterManager/CharacterCreationHandler"
@onready var user_list_handler = $"../UserListHandler"
@onready var user_fetch_handler = $"../UserFetchHandler"
@onready var database_list = $"../../../../../Control/MainVBoxContainer/MainHBoxContainer/ListContainer/DatabasePanel/DatabaseList"

# Erstelle eine eindeutige ID für den Benutzer
func create_unique_user_id() -> String:
	var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var random_component = ""
	for i in range(6):
		random_component += charset[int(randf() * charset.length())]
	
	# Kombiniere Unix-Zeit mit dem zufälligen String
	var unique_id = str(Time.get_unix_time_from_system()) + "_" + random_component
	return unique_id

# Create a new user and save character data separately
func create_user(username: String, password: String) -> Dictionary:
	var users_list = user_list_handler.load_users_list()

	# Check if the user already exists
	if username in users_list:
		print("User already exists: ", username)
		return {}  # User already exists
	
	# Create a unique user ID and directories for user and character data
	var user_id = create_unique_user_id()
	var user_dir = users_data_dir + user_id + "/"
	var character_dir = user_dir + "characters/"

	# Create the user directory if it doesn't exist
	var dir = DirAccess.open(user_dir)
	if dir == null:
		dir = DirAccess.open("user://")
		dir.make_dir_recursive(user_dir)
		print("Directory created for user: ", user_dir)

	# Create the character directory for the user
	dir = DirAccess.open(character_dir)
	if dir == null:
		dir = DirAccess.open("user://")
		dir.make_dir_recursive(character_dir)
		print("Character directory created: ", character_dir)
	
	# Create characters for the user and save them as individual files
	var characters = character_creation_handler.create_characters_for_user(user_id)
	var character_ids = []

	for character in characters:
		var character_id = character.get("character_id")
		var character_file_path = character_dir + character_id + ".json"
		var character_file = FileAccess.open(character_file_path, FileAccess.WRITE)
		
		if character_file != null:
			character_file.store_string(JSON.stringify(character, "\t"))  # Pretty print for easier debugging
			character_file.close()
			print("Character data saved successfully for character ID:", character_id)
			character_ids.append(character_id)
		else:
			print("Failed to create character file for ID:", character_id)
	
	# Hash the user's password
	var hashed_password = hash_password(password)
	var user_data = {
		"user_id": user_id,
		"username": username,
		"password": hashed_password,
		"character_ids": character_ids,  # Store only character IDs in the user data
	}

	# Save the user data as a JSON file
	var user_file_path = user_dir + "user_data.json"
	var user_file = FileAccess.open(user_file_path, FileAccess.WRITE)
	if user_file != null:
		user_file.store_string(JSON.stringify(user_data))
		user_file.close()
		
		# Add the new user to the users list and save it
		users_list.append({"username": username, "user_id": user_id})
		user_list_handler.save_users_list(users_list)
		database_list.request_update()
		print("User created: ", username, " with User ID: ", user_id)
		return user_data  # Return the complete user data
	else:
		print("Failed to create user file for:", username)
		return {}


# Passwort mit SHA-256 hashen
func hash_password(password: String) -> String:
	var ctx = HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	ctx.update(password.to_utf8_buffer())
	var hashed_password = ctx.finish()
	return hashed_password.hex_encode()  # In Hex-String umwandeln
