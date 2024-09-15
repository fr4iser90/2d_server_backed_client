# res://src/core/game_manager/player_manager/CharacterManager.gd
extends Node

signal character_data_changed  # Signal to notify when character data is added/updated/removed

var characters_data: Dictionary = {}  # Holds all character-specific data

var spawn_manager
var user_session_manager
var instance_manager 
var player_movement_manager

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	spawn_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "spawn_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	is_initialized = true
	
func add_character_to_manager(peer_id: int, character_data: Dictionary):
	var existing_character_data = characters_data.get(peer_id, {})
	
	for key in character_data.keys():
		existing_character_data[key] = character_data[key]

	characters_data[peer_id] = existing_character_data
	print("Character added/updated for peer_id: ", peer_id)
	_emit_character_data_signal(peer_id)

func update_character_data(peer_id: int, updated_data: Dictionary):
	if characters_data.has(peer_id):
		var character_data = characters_data[peer_id]
		for key in updated_data.keys():
			character_data[key] = updated_data[key]
		characters_data[peer_id] = character_data
		_emit_character_data_signal(peer_id)

func remove_character(peer_id: int):
	characters_data.erase(peer_id)
	_emit_character_data_signal(peer_id)

func get_character_data(peer_id: int) -> Dictionary:
	return characters_data.get(peer_id, {})

func _emit_character_data_signal(peer_id: int):
	emit_signal("character_data_changed", peer_id, characters_data.get(peer_id, {}))
