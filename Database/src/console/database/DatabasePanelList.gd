extends ItemList

@onready var user_list_handler = $"../../../../../../Source/Database/User/UserManager/UserListHandler"
@onready var character_fetch_handler = $"../../../../../../Source/Database/Character/CharacterManager/CharacterFetchHandler"

@onready var user_fetch_handler = $"../../../../../../Source/Database/User/UserManager/UserFetchHandler"
var cached_users = []  # Cache to store the last state of users and characters

signal update_requested

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("update_requested", Callable(self, "_update_database_list"))
	_update_database_list()  # Perform the initial fetch when the scene is loaded

func request_update():
	emit_signal("update_requested")

# Removes the user from the users_list_file after deletion
func remove_user_from_list(user_id: String) -> void:
	var users_list = user_list_handler.load_users_list()
	
	# Filter the list to exclude the deleted user
	users_list = users_list.filter(func(user_entry):
		return user_entry["user_id"] != user_id
	)
	
	# Save the updated users list
	user_list_handler.save_users_list(users_list)

	# Update the UI to reflect the changes
	request_update()
	
# Fetch user and character data, updating the ItemList if needed
func _update_database_list():
	var users = user_fetch_handler.fetch_all_users()  # Fetch all users
	if _has_data_changed(users):
		clear()  # Clear the list if data has changed

		# Update UI with user and character details
		for user in users:
			var username = user.get("username", "Unknown User")
			var user_id = user.get("user_id", "Unknown ID")
			var character_ids = user.get("character_ids", [])

			add_item("User: " + username + "| Characters: " + str(character_ids.size()) + " | ID: " + user_id)
			_add_characters_to_list(user_id, character_ids)

		# Cache the updated users
		cached_users = users.duplicate(true)

# Helper to add characters to the list by fetching their data using IDs
func _add_characters_to_list(user_id: String, character_ids: Array):
	for character_id in character_ids:
		var characters = character_fetch_handler.load_character_data(user_id, character_id)
		var character_data = characters.get("data", {})
		if character_data.size() > 0:  # Only proceed if character data was successfully fetched
			var character_name = character_data.get("name", "Unknown Character")
			var character_level = character_data.get("level", 1)
			var character_area = character_data.get("current_area", "Unknown Area")
			var character_class = character_data.get("character_class", "Unknown Class")
			var character_position = character_data.get("current_position", "Unknown Position")
			
			add_item("         Character: " + character_name + "| Class: " + character_class + "| Level: " + str(character_level) + "| Area: " + character_area + "| Position: " + character_position)

# Helper to check if user or character data has changed
func _has_data_changed(new_users: Array) -> bool:
	if new_users.size() != cached_users.size():
		return true

	for i in range(new_users.size()):
		var new_user = new_users[i]
		var cached_user = cached_users[i]

		# Check for changes in user data
		if new_user.get("username") != cached_user.get("username") or \
		   new_user.get("user_id") != cached_user.get("user_id"):
			return true

		# Check for changes in character data
		if _has_characters_changed(new_user.get("characters", []), cached_user.get("characters", [])):
			return true

	return false

# Helper to check if character data has changed
func _has_characters_changed(new_characters: Array, cached_characters: Array) -> bool:
	if new_characters.size() != cached_characters.size():
		return true

	for i in range(new_characters.size()):
		var new_character = new_characters[i]
		var cached_character = cached_characters[i]

		if new_character.get("name") != cached_character.get("name") or \
		   new_character.get("level") != cached_character.get("level") or \
		   new_character.get("character_class") != cached_character.get("character_class"):
			return true

	return false
