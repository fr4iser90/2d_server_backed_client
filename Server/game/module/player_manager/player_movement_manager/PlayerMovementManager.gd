# PlayerMovementManager
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)

@onready var player_movement_validation_handler = $Handler/PlayerMovementValidationHandler
@onready var player_movement_position_sync_handler = $Handler/PlayerMovementPositionSyncHandler
@onready var player_movement_obstacle_detection_handler = $Handler/PlayerMovementObstacleDetectionHandler
@onready var player_movement_trigger_handler = $Handler/PlayerMovementTriggerHandler
@onready var player_movement_update_handler = $Handler/PlayerMovementUpdateHandler
@onready var player_movement_state_handler = $Handler/PlayerMovementStateHandler
@onready var player_movmement_process_handler = $Handler/PlayerMovmementProcessHandler


var players = {}  # Stores player nodes or references to player data
var player_positions = {}  # Stores player positions and other relevant data
var instance_manager
var navigation_mesh_manager
var chunk_manager
var trigger_manager
var is_initialized = false

func _ready():
	initialize()

# Initialize the PlayerMovementManager
func initialize():
	if is_initialized:
		print("PlayerMovement already initialized. Skipping.")
		return
	is_initialized = true
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	chunk_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "chunk_manager")
	navigation_mesh_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "navigation_mesh_manager")
	trigger_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "trigger_manager")
	
	# Initialize all handlers
	player_movement_validation_handler.initialize(self)
	player_movement_position_sync_handler.initialize(self)
	player_movement_obstacle_detection_handler.initialize(self)
	player_movement_trigger_handler.initialize(self)
	player_movement_state_handler.initialize(self)
	player_movmement_process_handler.initialize(self)
	player_movement_update_handler.initialize(self)

# Add a player to the manager
func add_player(peer_id: int, player_data: Dictionary, spawn_point: Vector2):
	return player_movement_update_handler.add_player(peer_id, player_data, spawn_point)

func get_checkpoint_position(checkpoint_id: String) -> Vector2:
	return player_movement_update_handler.get_checkpoint_position(checkpoint_id)

# Remove player when they disconnect
func remove_player(peer_id: int):
	return player_movement_update_handler.remove_player(peer_id)

# Process received movement data and update the player's position
func process_received_data(peer_id: int, movement_data: Dictionary):
	return player_movmement_process_handler.process_received_data(peer_id, movement_data)

# Handle modular additional data (e.g., player states, rotations, etc.)
func process_additional_data(peer_id: int, additional_data: Dictionary):
	return player_movmement_process_handler.process_additional_data(peer_id, additional_data)

func is_valid_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool:
	return player_movement_validation_handler.is_valid_movement(peer_id, new_position, velocity)
	
# Utility to retrieve all players' data (positions, velocities, etc.)
func get_all_players_data() -> Dictionary:
	return player_positions

# Function to get all player IDs
func get_all_player_ids() -> Array:
	return player_positions.keys()

# Function to retrieve the player's position
func get_player_position(peer_id: int) -> Vector2:
	if player_positions.has(peer_id):
		return player_positions[peer_id]["position"]
	else:
		print("No position found for peer_id:", peer_id)
		return Vector2()  # Return a default Vector2 if the position is not found
