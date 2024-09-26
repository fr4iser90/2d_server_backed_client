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
	#session_lock_type_handler = GlobalManager.NodeManager.get_cached_node("user_session_manager", "session_lock_type_handler")
	timeout_handler = GlobalManager.NodeManager.get_cached_node("user_session_manager", "timeout_handler")
	
	print("UserSessionManager initialized and connected to signals.")


# Add user without character or instance data, to be updated when signals are received
func add_user_to_manager(peer_id: int, user_data: Dictionary) -> bool:
	var username = user_data.get("username", "Unknown")
	
	# Check if this peer_id already has a session with a different username
	if users_data.has(peer_id):
		var current_username = users_data[peer_id].get("username", "")
		if current_username != "" and current_username != username:
			print("Error: Peer is trying to log in as a different username.")
			return false  # Prevent overwriting session with a new username

	# Check if session is already locked by username
	if session_lock_handler.is_session_locked(username):
		print("User session already locked for username:", username)
		return false  # Prevent further processing if session is locked
	
	# Proceed with adding the user data
	var existing_user_data = users_data.get(peer_id, {})
	existing_user_data["username"] = username
	existing_user_data["user_id"] = user_data.get("user_id", "")
	existing_user_data["token"] = user_data.get("token", "")
	existing_user_data["peer_id"] = peer_id
	existing_user_data["is_online"] = true

	# Lock the session for this username
	session_lock_handler.lock_session(username)

	# Store the user data in the session manager
	users_data[peer_id] = existing_user_data
	_emit_user_data_signal(peer_id)
	return true

# Called when the character is selected
func _on_character_selected(peer_id: int, character_data: Dictionary):
	if users_data.has(peer_id):
		var user_data = users_data.get(peer_id, {})
		user_data["character"] = character_data.duplicate(true)
		users_data[peer_id] = user_data
		_emit_user_data_signal(peer_id)
	else:
		print("Error: Peer ID not found in users_data")

func _emit_user_data_signal(peer_id: int):
	emit_signal("user_data_changed", peer_id, users_data.get(peer_id, {}))

func update_user_data(peer_id: int, updated_data: Dictionary):
	if not users_data.has(peer_id):
		print("User not found, creating new user for peer_id:", peer_id)
		add_user_to_manager(peer_id, updated_data)
	else:
		var user_data = users_data[peer_id]
		var current_username = user_data.get("username", "")
		var new_username = updated_data.get("username", current_username)

		# If the username is being changed, log and handle this case
		if current_username != "" and current_username != new_username:
			print("Warning: Username change attempted for peer_id:", peer_id)
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
		print("User removed with Peer ID:", peer_id, "and Username:", username)

func get_user_data(peer_id: int) -> Dictionary:
	return users_data.get(peer_id, {})

func get_username_by_peer_id(peer_id: int) -> String:
	var user_data = get_user_data(peer_id)
	if user_data.has("username"):
		return user_data["username"]
	return "Unknown"


func validate_user_token(peer_id: int, token: String) -> bool:
	var user_data = users_data.get(peer_id, null)
	if user_data and user_data.has("token"):
		return user_data["token"] == token
	return false

# Handle session timeout
func _on_session_timeout(peer_id: int):
	remove_user(peer_id)
	print("Session for peer_id", peer_id, "timed out and removed.")
