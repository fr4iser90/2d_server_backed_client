# res://src/game/player_manager/PlayerMovementManager.gd (Server)
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)

var players = {}  # Stores player nodes or references to player data
var player_positions = {}  # Stores player positions and other relevant data

var is_initialized = false

func _ready():
	initialize()

func initialize():
	if is_initialized:
		print("PlayerMovement already initialized. Skipping.")
		return
	is_initialized = true

# Add a player to the manager
func add_player(peer_id: int, player_data: Dictionary):
	# Access the position directly from player_data
	#print("player_data: ", player_data)
	if player_data.has("last_known_position"):
		var position = player_data["last_known_position"]
		
		# Add player data and initialize the position
		players[peer_id] = player_data
		player_positions[peer_id] = position  # Initialize position
		print("Player added to movement manager: ", peer_id, " with position: ", position)
	else:
		print("Failed to add player for peer_id: ", peer_id, " - invalid player_data")


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
			player_positions[peer_id]["position"] = new_position
			player_positions[peer_id]["velocity"] = velocity
			emit_signal("player_position_updated", peer_id, new_position)

			# Process modular additional data
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
