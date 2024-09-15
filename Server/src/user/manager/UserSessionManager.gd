# res://src/core/network/network_meta_manager/UserSessionManager.gd
extends Node

signal user_data_changed  # Signal to notify when user data is added/updated/removed

var users_data: Dictionary = {}  # Holds all active user data (user-specific info)
var character_manager = null # Reference to CharacterManager

var is_initialized = false  

# Initialize the manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	
# Ready function to initialize
func _ready():
	if not is_initialized:
		initialize()
	
	

func add_user_to_manager(peer_id: int, user_data: Dictionary):
	var existing_user_data = users_data.get(peer_id, {})
	
	existing_user_data["username"] = user_data.get("username", "Unknown")
	existing_user_data["user_id"] = user_data.get("user_id", "")
	existing_user_data["token"] = user_data.get("token", "")
	existing_user_data["peer_id"] = peer_id  # Unique ID assigned for the session
	existing_user_data["is_online"] = true
	
	users_data[peer_id] = existing_user_data
	print("User added/updated: ", existing_user_data["username"])
	_emit_user_data_signal(peer_id)

func attach_character_to_user(peer_id: int):
	if character_manager:
		var character_data = character_manager.get_character_data(peer_id)
		if character_data:
			# Hole die User-Daten für den gegebenen Peer ID
			var user_data = users_data.get(peer_id, {})

			# Füge die Charakterdaten zum User hinzu
			user_data["character"] = character_data
			users_data[peer_id] = user_data

			# Stelle sicher, dass "username" im Dictionary existiert, bevor du darauf zugreifst
			if user_data.has("username"):
				print("Character attached to user: ", user_data["username"])
			else:
				print("Character attached, but username is missing for peer_id: ", peer_id)

			_emit_user_data_signal(peer_id)  # Signal auslösen
		else:
			print("No character data found for peer_id: ", peer_id)
	else:
		print("CharacterManager not found.")



func _emit_user_data_signal(peer_id: int):
	emit_signal("user_data_changed", peer_id, users_data.get(peer_id, {}))

func update_user_data(peer_id: int, updated_data: Dictionary):
	if not users_data.has(peer_id):
		print("User not found, creating new user for peer_id:", peer_id)
		add_user_to_manager(peer_id, updated_data)
	else:
		var user_data = users_data[peer_id]
		for key in updated_data.keys():
			user_data[key] = updated_data[key]
		users_data[peer_id] = user_data
		_emit_user_data_signal(peer_id)

func remove_user(peer_id: int):
	users_data.erase(peer_id)
	_emit_user_data_signal(peer_id)

func get_user_data(peer_id: int) -> Dictionary:
	return users_data.get(peer_id, {})

func validate_user_token(peer_id: int, token: String) -> bool:
	var user_data = users_data.get(peer_id, null)
	if user_data and user_data.has("token"):
		return user_data["token"] == token
	return false
