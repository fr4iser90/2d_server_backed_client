# res://src/game/player_manager/CharacterManager.gd (Client)
extends Node

signal character_data_changed  # Signal to notify when character data is added/updated/removed

var characters_data: Dictionary = {}  # Holds all character-specific data
var selected_character_data: Dictionary = {}  # Stores the currently selected character's data

# Initialize the manager if needed
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true

# Store or update character data for the peer (typically a user ID)
func add_character_to_manager(peer_id: String, character_data: Dictionary):
	characters_data[peer_id] = character_data
	selected_character_data = character_data  # Store the selected character's data
	emit_signal("character_data_changed", peer_id, character_data)
	print("Character data added/updated for peer_id: ", peer_id)

# Update existing character data with new information
func update_character_data(peer_id: String, updated_data: Dictionary):
	if characters_data.has(peer_id):
		var character_data = characters_data[peer_id]
		for key in updated_data.keys():
			character_data[key] = updated_data[key]
		characters_data[peer_id] = character_data
		emit_signal("character_data_changed", peer_id, character_data)
		#print("Character data updated for peer_id: ", peer_id)
	else:
		print("No character data found for peer_id: ", peer_id)

# Remove character data when the user logs out or disconnects
func remove_character(peer_id: String):
	if characters_data.has(peer_id):
		characters_data.erase(peer_id)
		emit_signal("character_data_changed", peer_id, {})
		print("Character data removed for peer_id: ", peer_id)

# Get character data for a specific peer
func get_character_data(peer_id: String) -> Dictionary:
	return characters_data.get(peer_id, {})

# Retrieve the selected character data
func get_selected_character_data() -> Dictionary:
	return selected_character_data

# Optional: Reset selected character data when needed
func reset_selected_character():
	selected_character_data = {}
	print("Selected character data reset")

