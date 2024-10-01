# DatabasePanelList.gd
extends ItemList

@onready var database_fetch = $"../../../../Source/Database/Utility/DatabaseFetch"
@export var update_interval: float = 5.0  # Update interval in seconds
var update_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create and start the update timer
	update_timer = Timer.new()
	add_child(update_timer)
	update_timer.set_wait_time(update_interval)
	update_timer.set_one_shot(false)
	update_timer.connect("timeout", Callable(self, "_update_database_list"))
	update_timer.start()

# Function to fetch user and character data and update the ItemList
func _update_database_list():
	clear()  # Clear the current list

	# Fetch all users
	var users = database_fetch.fetch_all_users()

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

# _process is not needed in this case, as we handle updates via a timer.
