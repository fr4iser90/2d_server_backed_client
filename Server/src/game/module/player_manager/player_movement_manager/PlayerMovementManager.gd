extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)

var players = {}  # Stores player nodes or references to player data
var player_positions = {}  # Stores player positions and other relevant data
var instance_manager
var trigger_manager
var is_initialized = false

func _ready():
	initialize()

func initialize():
	if is_initialized:
		print("PlayerMovement already initialized. Skipping.")
		return
	is_initialized = true
	trigger_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "trigger_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")

# Add a player to the manager
func add_player(peer_id: int, player_data: Dictionary, spawn_point: Vector2):
	print("Player added to Movement Manager player_data: ", player_data)
	# Use checkpoint or spawn point for initial spawn
	if player_data.has("checkpoint_id"):
		var checkpoint_position = get_checkpoint_position(player_data["checkpoint_id"])
		# Register the player and their initial position
		players[peer_id] = player_data
		player_positions[peer_id] = {
			"position": checkpoint_position,
			"velocity": Vector2()  # Initial velocity (could be zero)
		}
	else:
		# Set the initial spawn point
		player_data["position"] = spawn_point  # Initial position at spawn point
		players[peer_id] = player_data
		player_positions[peer_id] = {
			"position": spawn_point,
			"velocity": Vector2()  # Initial velocity
		}

func get_checkpoint_position(checkpoint_id: String) -> Vector2:
	# Implement logic to retrieve the checkpoint position from your world/scene
	match checkpoint_id:
		"default_spawn_point":
			return Vector2(25, 25)  # Example coordinates for default spawn
		# Add more checkpoint handling if needed
		_:
			return Vector2(0, 0)  # Fallback position

# Remove player when they disconnect
func remove_player(peer_id: int):
	players.erase(peer_id)
	player_positions.erase(peer_id)
	print("Player removed from movement tracking: ", peer_id)

# Process received movement data and update the player's position
func process_received_data(peer_id: int, movement_data: Dictionary):
	var new_position = movement_data.get("position", Vector2())
	var velocity = movement_data.get("velocity", Vector2())
	var additional_data = movement_data.get("additional_data", {})

	# Validate and update the player's position
	if is_valid_movement(peer_id, new_position, velocity):
		if player_positions.has(peer_id):
			# Ensure player_positions is a Dictionary containing both position and velocity
			player_positions[peer_id]["position"] = new_position
			player_positions[peer_id]["velocity"] = velocity
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
		player_positions[peer_id]["state"] = player_state

# Simple validation logic for movement
func is_valid_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool:
	# You can add collision checks, velocity limits, etc.
	return true

# Utility to retrieve all players' data (positions, velocities, etc.)
func get_all_players_data() -> Dictionary:
	return player_positions

# Function to retrieve the player's position
func get_player_position(peer_id: int) -> Vector2:
	if player_positions.has(peer_id):
		return player_positions[peer_id]["position"]
	else:
		print("No position found for peer_id:", peer_id)
		return Vector2()  # Return a default Vector2 if the position is not found

# Function to get all player IDs
func get_all_player_ids() -> Array:
	return player_positions.keys()
