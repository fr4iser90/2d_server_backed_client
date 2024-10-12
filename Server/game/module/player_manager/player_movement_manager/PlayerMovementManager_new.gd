# res://src/game/player_manager/PlayerMovementManager.gd (Server)
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)

signal player_entered_trigger(peer_id: int, trigger_name: String, trigger_type: String)
signal player_exited_trigger(peer_id: int, trigger_name: String, trigger_type: String)

var players = {}  # Stores player nodes or references to player data
var player_positions = {}  # Stores player positions and other relevant data
var player_instances = {}  # Store the instance that each player belongs to
var player_chunks = {}  # Speichert, in welchem Chunk sich jeder Spieler befindet

var trigger_manager
var instance_manager
var is_initialized = false

func _ready():
	initialize()

func initialize():
	if is_initialized:
		print("PlayerMovement already initialized. Skipping.")
		return
	is_initialized = true
#	connect("player_entered_trigger", Callable($"../TriggerManager", "_on_trigger_activated"))
#	connect("player_exited_trigger", Callable($"../TriggerManager", "_on_trigger_deactivated"))
	trigger_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "TriggerManager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceManager")
# Add a player to the manager
func add_player(peer_id: int, player_data: Dictionary, spawn_point: Vector2):
	print("Player added to Movement Manager player_data: ", player_data)
	
	# Assign player to their instance
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	player_instances[peer_id] = instance_key
	# Use checkpoint or spawn point for initial spawn
	if player_data.has("checkpoint_id"):
		var checkpoint_position = get_checkpoint_position(player_data["checkpoint_id"])
		# Register the player and their initial position
		players[peer_id] = player_data
		player_positions[peer_id] = {
			"position": checkpoint_position,
			"velocity": Vector2()  # Initial velocity (could be zero)
		}
		print("Player added to movement manager: ", peer_id, " with position: ", checkpoint_position)
	else:
		# Set the initial spawn point
		player_data["position"] = spawn_point  # Initial position at spawn point
		players[peer_id] = player_data
		player_positions[peer_id] = {
			"position": spawn_point,
			"velocity": Vector2()  # Initial velocity
		}
		print("Player added to movement manager at spawn point: ", spawn_point)

func get_checkpoint_position(checkpoint_id: String) -> Vector2:
	# Here you can implement logic to retrieve the checkpoint position from your world/scene
	# For now, return a mock position based on the checkpoint
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
	player_instances.erase(peer_id)  # Also remove from instance tracking
	player_chunks.erase(peer_id)  # Also remove from instance tracking
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
			
			# Detect triggers (entry/exit)
			detect_trigger_events(peer_id, new_position)
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

# Detect trigger entry and exit events based on player position
func detect_trigger_events(peer_id: int, new_position: Vector2):
	var instance_key = get_player_instance(peer_id)
	var old_position = player_positions[peer_id]["position"]
	
	var old_trigger = detect_trigger(instance_key, old_position)
	var new_trigger = detect_trigger(instance_key, new_position)

	if old_trigger != new_trigger:
		if new_trigger:
			emit_signal("player_entered_trigger", peer_id, new_trigger["name"], new_trigger["type"])
		if old_trigger:
			emit_signal("player_exited_trigger", peer_id, old_trigger["name"], old_trigger["type"])

# Utility to detect if a player is inside a trigger zone (returns a dictionary with trigger info)
func detect_trigger(instance_key: String, position: Vector2) -> Dictionary:
	# Logic to detect if the player is in a trigger based on the instance
	var trigger_data = trigger_manager.get_triggers_for_instance(instance_key)
	# Check the player's position against the triggers
	# Example logic here
	for trigger in trigger_data:
		if position.x >= trigger["position"].x and position.x <= trigger["position"].x + trigger["area_size"].x:
			if position.y >= trigger["position"].y and position.y <= trigger["position"].y + trigger["area_size"].y:
				return trigger  # Return the trigger info if inside
	return {}  # No trigger found
	
# Simple validation logic for movement
func is_valid_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool:
	# You can add collision checks, velocity limits, etc.
	return true

# Get the instance a player belongs to
func get_player_instance(peer_id: int) -> String:
	return player_instances.get(peer_id, "")
	
# Utility to retrieve all players' data (positions, velocities, etc.)
func get_all_players_data() -> Dictionary:
	return player_positions
