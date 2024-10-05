# PlayerMovementProcessHandler.gd
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)
@onready var player_movement_manager = $"../.."

@onready var player_movement_validation_handler = $"../PlayerMovementValidationHandler"
@onready var player_movement_position_sync_handler = $"../PlayerMovementPositionSyncHandler"
@onready var player_movement_obstacle_detection_handler = $"../PlayerMovementObstacleDetectionHandler"
@onready var player_movement_trigger_handler = $"../PlayerMovementTriggerHandler"
@onready var player_movement_update_handler = $"../PlayerMovementUpdateHandler"
@onready var player_movement_state_handler = $"../PlayerMovementStateHandler"

func initialize(parent: Node):
	print("Initializing PlayerMovementProcessHandler")

# Process received movement data and update the player's position
func process_received_data(peer_id: int, movement_data: Dictionary):
	var new_position = movement_data.get("position", Vector2())
	var velocity = movement_data.get("velocity", Vector2())
	var additional_data = movement_data.get("additional_data", {})

	# Validate and update the player's position
	if player_movement_validation_handler.is_valid_movement(peer_id, new_position, velocity):
		if player_movement_manager.player_positions.has(peer_id):
			# Ensure player_positions is a Dictionary containing both position and velocity
			player_movement_manager.player_positions[peer_id]["position"] = new_position
			player_movement_manager.player_positions[peer_id]["velocity"] = velocity
			emit_signal("player_position_updated", peer_id, new_position)
			# No need to check for trigger interaction here; TriggerManager handles it
			process_additional_data(peer_id, additional_data)
		else:
			print("No player data found for peer_id: ", peer_id)

# Handle modular additional data (e.g., player states, rotations, etc.)
func process_additional_data(peer_id: int, additional_data: Dictionary):
	if additional_data.has("state"):
		var player_state = additional_data["state"]
		print("Processing player state for peer_id ", peer_id, ": ", player_state)
		# Update player state if necessary
		player_movement_manager.player_positions[peer_id]["state"] = player_state
