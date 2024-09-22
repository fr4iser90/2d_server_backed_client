# res://src/core/network/handler/backend_rest/movement_player_sync_handler.gd (Client)
extends Node

var instance_manager = null
var is_initialized = false

# Initialize the handler and instance manager
func initialize():
	if is_initialized:
		return
	is_initialized = true
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	print("MovementPlayerSyncHandler initialized.")

# Client-side: handle_packet in movement_player_sync_handler.gd
func handle_packet(data: Dictionary):
	if data.has("players_movement_data"):
		var players_movement_data = data["players_movement_data"]
		for peer_id in players_movement_data.keys():
			var movement_data = players_movement_data[peer_id]
			
			# Validate movement data contains position and velocity
			if movement_data.has("position") and movement_data.has("velocity"):
				var position = _convert_to_vector2(movement_data["position"])
				var velocity = _convert_to_vector2(movement_data["velocity"])

				if instance_manager:
					# Delegate the entity creation and position update to the instance manager
					instance_manager.handle_entity_movement("players", int(peer_id), position, velocity)
				else:
					print("Error: InstanceManager not found!")
			else:
				print("Invalid movement data for peer_id:", peer_id, ", missing position or velocity.")
	else:
		print("Invalid movement data received.")

# Helper to convert incoming data into Vector2
func _convert_to_vector2(data: Dictionary) -> Vector2:
	if data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	else:
		return Vector2.ZERO
