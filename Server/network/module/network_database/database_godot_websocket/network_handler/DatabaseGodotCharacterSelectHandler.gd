# DatabaseGodotCharacterSelectHandler
extends Node

signal character_selected_success(peer_id: int, character_data: Dictionary)
signal character_selection_failed(reason: String)

var user_session_manager
var character_manager
var instance_manager
var character_name
var is_initialized = false

func initialize():
	if is_initialized:
		return
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	character_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "character_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	is_initialized = true

# Process character selection and return result to the client handler
func process_character_selection(peer_id: int, character_name: String):
	print("character_name : ", character_name)
	var character_data = character_manager.select_character_for_peer(peer_id, character_name)

	print("CHAR SELECT DATA: ", character_data)
	if character_data.size() == 0:
		GlobalManager.DebugPrint.debug_error("Character data not found for name: " + str(character_name), self)
		emit_signal("character_selection_failed", "Character data not found for name")
		return

	# Clean the character data (removing any sensitive or unnecessary fields)
	var cleaned_character_data = clean_character_data(character_data)

	# Handle instance assignment for the selected character
	var instance_key = instance_manager.handle_player_character_selected(peer_id, cleaned_character_data)

	# Prepare response data to send back to client
	var response_data = {
		"characters": cleaned_character_data,
		"instance_key": instance_key
	}

	# Emit success signal to notify the client handler
	emit_signal("character_selected_success", peer_id, response_data)

# Clean character data before sending it to the client
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)
	cleaned_data.erase("user")
	cleaned_data.erase("id")
	cleaned_data.erase("_id")
	return cleaned_data
