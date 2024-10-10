# PlayerMovementUpdateHandler.gd
extends Node

var parent_movement_manager

func initialize(parent: Node):
	parent_movement_manager = parent
	print("Initializing PlayerMovementUpdateHandler")


# Add a player to the manager
func add_player(peer_id: int, player_data: Dictionary, spawn_point: Vector2):
	print("Player added to Movement Manager player_data: ", player_data)

	# Priority 1: Use current_position if available
	if player_data.has("current_position") and player_data["current_position"] != "":
		var current_position = _parse_position(player_data["current_position"])
		parent_movement_manager.players[peer_id] = player_data
		parent_movement_manager.player_positions[peer_id] = {
			"position": current_position,
			"velocity": Vector2()  # Initial velocity set to zero
		}
	# Priority 2: Use checkpoint position if available
	elif player_data.has("checkpoint_id") and player_data["checkpoint_id"] != "":
		var checkpoint_position = get_checkpoint_position(player_data["checkpoint_id"])
		parent_movement_manager.players[peer_id] = player_data
		parent_movement_manager.player_positions[peer_id] = {
			"position": checkpoint_position,
			"velocity": Vector2()  # Initial velocity set to zero
		}
	# Priority 3: Fallback to spawn point
	else:
		player_data["position"] = spawn_point  # Initial position at spawn point
		parent_movement_manager.players[peer_id] = player_data
		parent_movement_manager.player_positions[peer_id] = {
			"position": spawn_point,
			"velocity": Vector2()  # Initial velocity set to zero
		}

	print("Player position set for peer_id:", peer_id, ", position:", parent_movement_manager.player_positions[peer_id]["position"])

# Helper function to parse position from string to Vector2
func _parse_position(position_string: String) -> Vector2:
	position_string = position_string.replace("(", "").replace(")", "")
	var parts = position_string.split(", ")
	return Vector2(parts[0].to_float(), parts[1].to_float())
	
# Remove player when they disconnect
func remove_player(peer_id: int):
	parent_movement_manager.players.erase(peer_id)
	parent_movement_manager.player_positions.erase(peer_id)
	print("Player removed from movement tracking: ", peer_id)

func get_checkpoint_position(checkpoint_id: String) -> Vector2:
	# Implement logic to retrieve the checkpoint position from your world/scene
	match checkpoint_id:
		"default_spawn_point":
			return Vector2(25, 25)  # Example coordinates for default spawn
		# Add more checkpoint handling if needed
		_:
			return Vector2(0, 0)  # Fallback position
