# UserSessionManager.gd (Server)
extends Node

signal user_data_changed  # Signal to notify when user data is added/updated/removed

var session_lock_handler = null
var session_lock_type_handler = null
var timeout_handler = null

var users_data: Dictionary = {}  # Holds all active user data (user-specific info)

var character_manager = null
var instance_manager = null

var is_initialized = false  

# Initialize the manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	character_manager.connect("character_selected", Callable(self, "_on_character_selected"))
	
	# Initialize session handlers
	session_lock_handler = GlobalManager.NodeManager.get_cached_node("user_session_manager", "session_lock_handler")
	timeout_handler = GlobalManager.NodeManager.get_cached_node("user_session_manager", "timeout_handler")

	GlobalManager.DebugPrint.debug_info("UserSessionManager initialized.", self)

# Add user without character or instance data, to be updated when signals are received
func add_user_to_manager(peer_id: int, user_data: Dictionary) -> bool:
	var username = user_data.get("username", "Unknown")
	# Check if this peer_id already has a session with a different username
	if users_data.has(peer_id):
		var current_username = users_data[peer_id].get("username", "")
		if current_username != "" and current_username != username:
			GlobalManager.DebugPrint.debug_error("Error: Peer is trying to log in as a different username.", self)
			return false  # Prevent overwriting session with a new username

	# Check if session is already locked by username
	if session_lock_handler.is_session_locked(username):
		GlobalManager.DebugPrint.debug_warning("User session already locked for username: " + username, self)
		return false  # Prevent further processing if session is locked
	
	# Proceed with adding the user data
	var existing_user_data = users_data.get(peer_id, {})
	existing_user_data["username"] = username
	existing_user_data["user_id"] = user_data.get("user_id", "")
	existing_user_data["server_session_token"] = user_data.get("server_session_token", "")
	existing_user_data["database_session_token"] = user_data.get("database_session_token", "")
	existing_user_data["peer_id"] = peer_id
	existing_user_data["is_online"] = true

	# Lock the session for this username
	session_lock_handler.lock_session(username)

	# Store the user data in the session manager
	users_data[peer_id] = existing_user_data
	_emit_user_data_signal(peer_id)

	GlobalManager.DebugPrint.debug_info("User added to session: " + username, self)
	return true

# Retrieve session token for the peer
func get_server_session_token_for_peer(peer_id: int) -> String:
	if users_data.has(peer_id):
		return users_data[peer_id].get("server_session_token", "")
	return ""

# Retrieve auth token for the peer
func get_database_session_token_for_peer(peer_id: int) -> String:
	if users_data.has(peer_id):
		return users_data[peer_id].get("database_session_token", "")  # Retrieve the auth token
	return ""
	
# Called when the character is selected
func _on_character_selected(peer_id: int, character_data: Dictionary):
	if users_data.has(peer_id):
		var user_data = users_data.get(peer_id, {})
		user_data["character"] = character_data.duplicate(true)
		users_data[peer_id] = user_data
		_emit_user_data_signal(peer_id)
		GlobalManager.DebugPrint.debug_info("Character selected for peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_error("Error: Peer ID not found in users_data", self)
		
func get_character_id_by_class(peer_id: int, character_class: String) -> String:
	if users_data.has(peer_id):
		var user_data = users_data[peer_id]
		GlobalManager.DebugPrint.debug_debug("User data for peer_id: " + str(peer_id) + ": " + str(user_data), self)

		if user_data.has("characters"):
			var characters = user_data["characters"]
			
			# Check if the character data is an array
			if typeof(characters) == TYPE_ARRAY:
				GlobalManager.DebugPrint.debug_debug("Character data is an array for peer_id: " + str(peer_id), self)
				
				# Loop through all characters
				for character in characters:
					if character.has("character_class") and character["character_class"].to_lower() == character_class.to_lower():
						GlobalManager.DebugPrint.debug_info("Found character for class: " + character_class + " with character ID: " + character["id"], self)
						return character["id"]

			else:
				GlobalManager.DebugPrint.debug_warning("Unknown character data type for peer_id: " + str(peer_id), self)

	return ""  # No ID found

func _emit_user_data_signal(peer_id: int):
	emit_signal("user_data_changed", peer_id, users_data.get(peer_id, {}))

func get_character_data_by_class(peer_id: int, character_class: String) -> Dictionary:
	if users_data.has(peer_id):
		var user_data = users_data[peer_id]
		
		if user_data.has("characters"):
			var characters = user_data["characters"]
			
			# Check if the character data is an array
			if typeof(characters) == TYPE_ARRAY:
				for character in characters:
					print("get_character_data_by_class :", character)
					if character.has("character_class") and character["character_class"].to_lower() == character_class.to_lower():
						GlobalManager.DebugPrint.debug_info("Found character for class: " + character_class + " with character ID: " + character["id"], self)
						return character  # Return the full character data
			else:
				GlobalManager.DebugPrint.debug_warning("Unknown character data type for peer_id: " + str(peer_id), self)

	return {}  # Return empty Dictionary if no character is found


func update_user_data(peer_id: int, updated_data: Dictionary):
	if not users_data.has(peer_id):
		GlobalManager.DebugPrint.debug_warning("User not found, creating new user for peer_id: " + str(peer_id), self)
		add_user_to_manager(peer_id, updated_data)
	else:
		var user_data = users_data[peer_id]
		var current_username = user_data.get("username", "")
		var new_username = updated_data.get("username", current_username)

		# If the username is being changed, log and handle this case
		if current_username != "" and current_username != new_username:
			GlobalManager.DebugPrint.debug_warning("Username change attempted for peer_id: " + str(peer_id), self)
			return  # Block the update if you don't allow username changes mid-session

		# Proceed with updating the other data
		for key in updated_data.keys():
			user_data[key] = updated_data[key]
		users_data[peer_id] = user_data
		_emit_user_data_signal(peer_id)

func remove_user(peer_id: int):
	if users_data.has(peer_id):
		var user_data = users_data[peer_id]
		var username = user_data.get("username", "")
		
		# Unlock the session for the username
		session_lock_handler.unlock_session(username)
		
		# Remove all entries associated with this username from users_data
		for key in users_data.keys():
			if users_data[key].get("username", "") == username:
				users_data.erase(key)
		
		_emit_user_data_signal(peer_id)
		GlobalManager.DebugPrint.debug_info("User removed with Peer ID: " + str(peer_id) + " and Username: " + username, self)

func get_user_data(peer_id: int) -> Dictionary:
	return users_data.get(peer_id, {})

func get_user_id(peer_id: int) -> String:
	var user_data = get_user_data(peer_id)
	if user_data.has("user_id"):
		return user_data["user_id"]
	return "Unknown"
	
func get_username_by_peer_id(peer_id: int) -> String:
	var user_data = get_user_data(peer_id)
	if user_data.has("username"):
		return user_data["username"]
	return "Unknown"

func store_characters_for_peer(peer_id: int, characters: Array):
	if users_data.has(peer_id):
		# Update or add character data
		var user_data = users_data[peer_id]
		user_data["characters"] = characters
		users_data[peer_id] = user_data
		GlobalManager.DebugPrint.debug_info("Updated characters for peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_warning("Peer ID not found, cannot store characters.", self)

func get_characters_for_peer(peer_id: int) -> Array:
	if users_data.has(peer_id):
		var user_data = users_data[peer_id]
		if user_data.has("characters"):
			return user_data["characters"]
	return []

func validate_user_database_session_token(peer_id: int, database_session_token: String) -> bool:
	var user_data = users_data.get(peer_id, null)
	if user_data and user_data.has("database_session_token"):
		return user_data["database_session_token"] == database_session_token
	return false
	
# Validate the session token (e.g., session management token)
func validate_user_server_session_token(peer_id: int, server_session_token: String) -> bool:
	var user_data = users_data.get(peer_id, null)
	print(user_data)
	if user_data and user_data.has("server_session_token"):
		return user_data["server_session_token"] == server_session_token
	return false

# Handle session timeout
func _on_session_timeout(peer_id: int):
	remove_user(peer_id)
	GlobalManager.DebugPrint.debug_warning("Session for peer_id " + str(peer_id) + " timed out and removed.", self)
	
func generate_session_token(user_id: String) -> String:
	var token_source = user_id + str(Time.get_ticks_msec())
	var context = HashingContext.new()
	context.start(HashingContext.HASH_MD5)
	context.update(token_source.to_utf8_buffer())
	return context.finish().hex_encode()
