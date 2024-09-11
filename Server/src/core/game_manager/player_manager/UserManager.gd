#res://src/core/network/game_manager/player_manager/user_manager.gd (Server)
extends Node

signal user_data_changed  # Signal to notify when user data is added/updated/removed

var users_data: Dictionary = {}  # Holds all active user data

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	var character_select_handler = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_character_select_handler")
	character_select_handler.connect("character_selected_success", Callable(self, "_on_character_selected_success"))
	is_initialized = true

func _on_character_selected_success(peer_id: int, character_data: Dictionary):
	print("UserManager: Character selection success for peer: ", peer_id)
	print("Character Data: ", character_data)

	if character_data.has("character"):
		print("Character Portion: ", character_data["character"])

		# Fetch scene_name, spawn_point, and character_class directly from character data
		var character_info = character_data["character"]
		
		var scene_name = character_info.get("scene_name", "")
		var spawn_point = character_info.get("spawn_point", "")
		var character_class = character_info.get("character_class", "")
		print(scene_name, spawn_point, character_class)
		# Ensure scene_name and other required values are present
		if scene_name != "" and spawn_point != "" and character_class != "":
			# Character data is valid, add the user to the manager
			add_user_to_manager(peer_id, character_info)

			# Fetch InstanceManager for handling the player scene and spawn
			var instance_manager = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager")

			if instance_manager:
				# Pass the scene_name, spawn_point, and character_class directly to the instance manager
				instance_manager.handle_player_character_selected(peer_id, scene_name, spawn_point, character_class)
			else:
				print("Error: InstanceManager not found.")
		else:
			print("Error: Missing scene_name, spawn_point, or character_class.")
	else:
		print("Error: Character data missing.")


# Funktion zum Mappen der Short-Namen in die vollständigen Pfade
func map_short_paths(character_data: Dictionary) -> Dictionary:
	# Szenen-Pfad dynamisch mappen (z.B. scene_path, class)
	if character_data.has("scene_name"):
		var scene_path = GlobalManager.GlobalSceneConfig.get_scene_path(character_data["scene_name"])
		character_data["scene_path"] = scene_path

	# Beispiel für das Mappen der Klasse auf die entsprechenden Player-Szenen
	if character_data.has("class"):
		var class_scene = GlobalManager.GlobalSceneConfig.get_scene_path(character_data["class"].to_lower())
		character_data["class_scene"] = class_scene

	print("Mapped Character Data: ", character_data)
	return character_data


# Function to add a user to the manager
func add_user_to_manager(peer_id: int, character_data: Dictionary):
	# Check if the 'name' key exists in the character_data dictionary
	if character_data.has("name"):
		# Fetch existing data or initialize an empty dictionary if user doesn't exist
		var existing_user_data = users_data.get(peer_id, {})

		# Merge all keys from character_data into existing_user_data
		for key in character_data.keys():
			existing_user_data[key] = character_data[key]

		# Ensure required fields are present in user data, with default values if missing
		existing_user_data["name"] = character_data.get("name", "")
		existing_user_data["class"] = character_data.get("class", "")
		existing_user_data["level"] = character_data.get("level", 1)
		existing_user_data["experience"] = character_data.get("experience", 0)
		existing_user_data["scene_path"] = character_data.get("scene_path", "")  # Ensure scene_path is set
		existing_user_data["spawn_point"] = character_data.get("spawn_point", Vector2(100, 100))  # Default spawn point
		existing_user_data["stats"] = character_data.get("stats", {})  # Ensure stats are present
		existing_user_data["equipment"] = character_data.get("equipment", {})  # Ensure equipment is present
		existing_user_data["user_id"] = character_data.get("user", "")  # Ensure user ID is copied
		existing_user_data["inventory"] = character_data.get("inventory", [])  # Ensure inventory is copied

		# Update the users_data dictionary with the new data
		users_data[peer_id] = existing_user_data

		# Print the success message with the name for verification
		print("User added to manager: ", existing_user_data["name"])
		
		# Emit a signal that user data has changed
		_emit_user_data_signal(peer_id)
	else:
		print("Error: 'name' not found in character_data")

func _emit_user_data_signal(peer_id: int):
	# Emits signal with the full user data
	emit_signal("user_data_changed", peer_id, users_data.get(peer_id, {}))

# Function to update a user's character selection
func select_character(peer_id: int, character_data: Dictionary):
	if users_data.has(peer_id):
		update_user_data(peer_id, {
			"selected_character": character_data,
			"current_scene": character_data.get("scene_path", "")
		})

# Function to add a new user if not present in users_data
func add_user(peer_id: int, user_data: Dictionary):
	users_data[peer_id] = {
		"username": user_data.get("username", "Unknown"),
		"user_id": user_data.get("user_id", ""),
		"token": user_data.get("token", ""),
		"selected_character": {},  # To be updated when character is selected
		"character_list": user_data.get("character_list", []),
		"current_scene": user_data.get("current_scene", ""),
		"last_scene": user_data.get("last_scene", ""),
		"position": user_data.get("position", Vector3(0, 0, 0)),
		"is_online": true
	}
	_emit_user_data_signal(peer_id)  
	
# Dynamic function to update user data by traversing the packet and updating relevant fields
func update_user_data(peer_id: int, updated_data: Dictionary):
	if not users_data.has(peer_id):
		print("User not found, creating new user for peer_id:", peer_id)
		# Initialize basic user data with default values
		add_user(peer_id, updated_data)

	var user_data = users_data[peer_id]

	# Prevent overwriting critical data fields like 'username', 'peer_id', and 'user_id'
	var locked_fields = ["username", "peer_id", "user_id"]
	
	for key in updated_data.keys():
		if user_data.has(key):
			if key in locked_fields:
				print("Skipping update for locked field:", key)
				continue  # Skip the locked fields
			user_data[key] = updated_data[key]  # Update existing fields
		else:
			user_data[key] = updated_data[key]  # Add new fields if needed

	_emit_user_data_signal(peer_id)  
	print("User data updated for peer_id:", peer_id)

# Function to update user position
func update_position(peer_id: int, new_position: Vector3):
	update_user_data(peer_id, {"position": new_position})

# Function to remove a user when they disconnect
func remove_user(peer_id: int):
	users_data.erase(peer_id)
	_emit_user_data_signal(peer_id)  

# Get user data by peer_id
func get_user_data(peer_id: int) -> Dictionary:
	return users_data.get(peer_id, {})

# Example function to print user information
func print_user_info(peer_id: int):
	var user = get_user_data(peer_id)
	if not user.empty():
		print("User: ", user["name"], ", Character Class: ", user["class"], ", Scene: ", user["scene_path"])
	else:
		print("User not found.")
