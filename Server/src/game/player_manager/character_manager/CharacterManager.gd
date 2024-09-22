# res://src/game/character_manager/CharacterManager.gd (Server)
extends Node

signal character_data_changed  # Notify when character data is added/updated/removed
signal character_selected(peer_id: int, character_data: Dictionary)

var characters_data: Dictionary = {}  # Holds all character-specific data

var is_initialized = false  

# Initialize the manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	
# Add character data to the manager
func add_character_to_manager(peer_id: int, character_data: Dictionary):
	characters_data[peer_id] = character_data
	emit_signal("character_selected", peer_id, character_data)
	_emit_character_data_signal(peer_id)

# Update character data when it changes
func update_character_data(peer_id: int, updated_data: Dictionary):
	if characters_data.has(peer_id):
		var character_data = characters_data[peer_id]
		for key in updated_data.keys():
			character_data[key] = updated_data[key]
		characters_data[peer_id] = character_data
		_emit_character_data_signal(peer_id)

# Remove character data on logout/disconnection
func remove_character(peer_id: int):
	characters_data.erase(peer_id)
	_emit_character_data_signal(peer_id)

# Emit signal when character data changes
func _emit_character_data_signal(peer_id: int):
	emit_signal("character_data_changed", peer_id, characters_data.get(peer_id, {}))

# Retrieve character data
func get_character_data(peer_id: int) -> Dictionary:
	return characters_data.get(peer_id, {})
