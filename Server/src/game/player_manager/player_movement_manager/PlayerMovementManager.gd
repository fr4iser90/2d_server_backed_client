# res://src/game/player_manager/PlayerMovementManager.gd (Server)
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)
signal player_entered_trigger(peer_id: int, trigger_name: String, trigger_type: String)
signal player_exited_trigger(peer_id: int, trigger_name: String, trigger_type: String)

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
	
	connect("player_entered_trigger", Callable(trigger_manager, "_on_trigger_activated"))
	connect("player_exited_trigger", Callable(trigger_manager, "_on_trigger_deactivated"))

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
			check_for_trigger_interaction(peer_id, new_position)
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


# Check if a player has entered or exited a trigger
func check_for_trigger_interaction(peer_id: int, new_position: Vector2):
	# Use the InstanceManager to retrieve the player's instance key
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	
	if instance_key == "":
		print("Player", peer_id, "is not assigned to an instance.")
		return
	
	# Get the triggers for the current instance
	var triggers = trigger_manager.get_triggers_for_instance(instance_key)
	
	# Check if there are any triggers in the current instance
	if triggers.is_empty():
		print("No triggers found for instance:", instance_key)
		return
	
	# Iterate over trigger categories (player_trigger_point, npc_trigger_point, etc.)
	for category in triggers.keys():
		var category_triggers = triggers[category]
		
		# Iterate over the triggers within the category
		for trigger_name in category_triggers.keys():
			var trigger = category_triggers[trigger_name]
			
			# Ensure trigger contains 'global_position' and 'area_size'
			if trigger.has("global_position") and trigger.has("area_size"):
				var trigger_position = trigger["global_position"]
				var trigger_size = trigger["area_size"]
				
				# Simple bounds check to see if player is within the trigger area
				if is_position_in_area(new_position, trigger_position, trigger_size):
					emit_signal("player_entered_trigger", peer_id, trigger_name, category)
				else:
					emit_signal("player_exited_trigger", peer_id, trigger_name, category)



# Simple check if player position is within trigger bounds
func is_position_in_area(position: Vector2, area_position: Vector2, area_size: Vector2) -> bool:
	var half_size = area_size * 0.5
	return position.x > area_position.x - half_size.x and position.x < area_position.x + half_size.x and position.y > area_position.y - half_size.y and position.y < area_position.y + half_size.y
