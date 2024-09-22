# res://src/game/player_manager/PlayerManager.gd (Client)
extends Node

signal character_data_changed  # Signal to notify when character data is added/updated/removed

var characters_data: Dictionary = {}  # Holds all character-specific data
var selected_characters: Dictionary = {}  # Holds the selected character for each user

# Reference to other managers if needed
var character_manager = null
var spawn_manager = null
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	
func _ready():
	# Get reference to the CharacterInformationManager (if needed)
	character_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "character_manager")
	
	# Connect the signal to listen for character data changes (if needed)
	if character_manager:
		character_manager.connect("character_data_changed", Callable(self, "_on_character_data_changed"))

# Store or update character data for a user
func store_character_data(user_id: String, character_data: Dictionary):
	var character_id = character_data.get("_id", "")
	if character_id == "":
		print("Error: No valid character ID found.")
		return

	# Store character data for the user
	if not characters_data.has(user_id):
		characters_data[user_id] = []
	
	var found = false
	for i in range(len(characters_data[user_id])):
		if characters_data[user_id][i].get("_id", "") == character_id:
			characters_data[user_id][i] = character_data  # Update data
			found = true
			break
	
	# If character wasn't found, add new data
	if not found:
		characters_data[user_id].append(character_data)

	emit_signal("character_data_changed", user_id, characters_data[user_id])
	print("Character data stored for user: ", user_id, ", ID: ", character_id)

# Retrieve character data
func get_character_data(user_id: String, character_id: String) -> Dictionary:
	if characters_data.has(user_id):
		for character in characters_data[user_id]:
			if character.get("_id", "") == character_id:
				return character
	return {}

# Handle the logic for character selection
func handle_character_selected(user_id: String, character_id: String):
	selected_characters[user_id] = character_id
	print("Character selected for user: ", user_id, " -> Character ID: ", character_id)

	# Process logic for the selected character (e.g., loading stats, etc.)
	on_character_selected(user_id, character_id)

# Logic executed after character selection
func on_character_selected(user_id: String, character_id: String):
	print("Character selected for user: ", user_id, " -> Character ID: ", character_id)
	# Add any specific logic you want to trigger after character selection

# Optional: Handle character data changed signal (if needed)
func _on_character_data_changed(user_id: String, character_data: Dictionary):
	handle_character_selected(user_id, character_data.get("_id", ""))
