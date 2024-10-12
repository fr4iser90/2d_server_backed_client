# res://src/game/player_manager/PlayerManager.gd (Client)
extends Node

signal character_data_changed  # Signal to notify when character data is added/updated/removed

var characters_data: Dictionary = {}  # Holds all character-specific data, indexed by peer_id
var selected_characters: Dictionary = {}  # Holds the selected character for each user

var character_manager = null
var spawn_manager = null
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	
func _ready():
	character_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "CharacterManager")
	if character_manager:
		character_manager.connect("character_data_changed", Callable(self, "_on_character_data_changed"))

# Store or update character data for a user by peer_id
func store_character_data(peer_id: int, character_data: Dictionary):
	# Store character data for the peer_id
	characters_data[peer_id] = character_data

	emit_signal("character_data_changed", peer_id, character_data)
	print("Character data stored for peer_id: ", peer_id)

# Retrieve character data based on peer_id
func get_character_data(peer_id: int) -> Dictionary:
	if characters_data.has(peer_id):
		return characters_data[peer_id]
	return {}

# Handle character selection using peer_id
func handle_character_selected(peer_id: int):
	selected_characters[peer_id] = peer_id
	on_character_selected(peer_id)

# Logic executed after character selection
func on_character_selected(peer_id: int):
	var character_data = get_character_data(peer_id)
	if character_data:
		print("Character selected for peer_id: ", peer_id, " with data: ", character_data)
	else:
		print("Error: No character data found for peer_id: ", peer_id)

# Handle character data changed signal
func _on_character_data_changed(peer_id: int, character_data: Dictionary):
	handle_character_selected(peer_id)

