extends ItemList

@onready var database_fetch = $"../../../../../../Source/Database/Utility/DatabaseFetch"
var cached_users = []  # Cache to store the last state of users and characters

# Signal to be emitted when data should be updated
signal update_requested

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the signal to the function that updates the list
	connect("update_requested", Callable(self, "_update_database_list"))

	# Perform the initial fetch when the scene is loaded
	_update_database_list()

# External function or system triggers this signal when data changes
func request_update():
	emit_signal("update_requested")

# Function to fetch user and character data and update the ItemList if data has changed
func _update_database_list():
	# Fetch all users
	var users = database_fetch.fetch_all_users()

	# Compare new data with cached data
	if _has_data_changed(users):
		# Data has changed, clear and update the list
		clear()

		# Loop through each user and display their details
		for user in users:
			var username = user.get("username", "Unknown User")
			var characters = database_fetch.fetch_user_characters(user)

			# Add user information
			add_item("User: " + username + " (Characters: " + str(characters.size()) + ")")

			# Loop through each character and display their details
			for character in characters:
				var character_name = character.get("name", "Unknown Character")
				var level = character.get("level", 1)
				var character_class = character.get("character_class", "Unknown Class")

				# Add character details indented under the user
				add_item("    Character: " + character_name + " (Class: " + character_class + ", Level: " + str(level) + ")")

		# Update the cached users
		cached_users = users.duplicate(true)

# Helper function to check if user and character data has changed
func _has_data_changed(new_users):
	# If the number of users differs, data has changed
	if new_users.size() != cached_users.size():
		return true

	# Loop through each user to compare data
	for i in range(new_users.size()):
		var new_user = new_users[i]
		if i >= cached_users.size():
			# Cache is out of sync (fewer users than expected), update is needed
			return true

		var cached_user = cached_users[i]

		# Compare user details
		if new_user.get("username") != cached_user.get("username"):
			return true

		# Fetch characters for both users to compare them
		var new_characters = database_fetch.fetch_user_characters(new_user)
		var cached_characters = database_fetch.fetch_user_characters(cached_user)

		# If character count differs, data has changed
		if new_characters.size() != cached_characters.size():
			return true

		# Compare each character's data
		for j in range(new_characters.size()):
			var new_character = new_characters[j]
			var cached_character = cached_characters[j]

			# Compare character details
			if new_character.get("name") != cached_character.get("name") or \
			   new_character.get("level") != cached_character.get("level") or \
			   new_character.get("character_class") != cached_character.get("character_class"):
				return true

	# No changes detected
	return false
