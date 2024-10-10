# res://src/game/player_manager/PlayerManager.gd (Server)
extends Node

signal player_data_changed  # Notify when player data is added/updated/removed

var players = {}  # Tracks player nodes
var spawn_point_manager
var player_movement_manager

var is_initialized = false  

# Initialization logic for the manager
func initialize():
	if is_initialized:
		return
	spawn_point_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "spawn_point_manager")
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_player_module", "player_movement_manager")
	is_initialized = true

# Add player entity to the manager
func add_player(peer_id: int, player_node: Node):
	if player_node:
		players[peer_id] = player_node
		print("Player added: ", peer_id)
	else:
		print("Failed to add player for peer_id: ", peer_id)

# Remove player from the manager
func remove_player(peer_id: int):
	players.erase(peer_id)
	print("Player removed: ", peer_id)

# Handle player spawning based on character data
func handle_player_spawn(peer_id: int, character_data: Dictionary):
	var scene_name = character_data.get("scene_name", "")
	var spawn_point = character_data.get("spawn_point", "")
	var character_class = character_data.get("character_class", "")

	if scene_name and spawn_point and character_class:
		$Handler/PlayerSpawnHandler.spawn_player(peer_id, character_class, scene_name, spawn_point, false)
	else:
		print("Error: Missing character data for spawning.")

# Player movement logic
func process_received_data(peer_id: int, movement_data: Dictionary):
	var player = players.get(peer_id, null)
	if player:
		player.global_position = movement_data.get("position", Vector2())
		print("Updated position for player: ", peer_id)
	else:
		print("No player character found for peer_id: ", peer_id)
