# res://src/core/network/handler/packet_handlers/player_movement_handler.gd (Server)
extends Node

var enet_server_manager
var handler_name = "player_movement_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		print("PlayerMovementHandler already initialized. Skipping.")
		return
	enet_server_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_meta_manager", "enet_server_manager")
	is_initialized = true

# Handle incoming packets for player movement
func handle_packet(data: Dictionary, peer_id: int):
	var position = _convert_to_vector2(data.get("position", {}))
	var velocity = _convert_to_vector2(data.get("velocity", {}))
	
	# Debugging: Print the raw data
	print("Received raw data: ", data)
	print("Converted Position: ", position, " Type: ", typeof(position))
	print("Converted Velocity: ", velocity, " Type: ", typeof(velocity))
	
	if position != null and velocity != null:
		if position != Vector2.ZERO and velocity != Vector2.ZERO:
			process_movement_data(peer_id, position, velocity)
		else:
			print("Invalid position or velocity for peer_id ", peer_id)
	else:
		print("Position or velocity data is not a valid Vector2 for peer_id ", peer_id)

# Converts incoming data to Vector2
func _convert_to_vector2(data) -> Vector2:
	if data is Dictionary and data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	elif data is String:
		var cleaned_data = data.replace("(", "").replace(")", "")
		var parts = cleaned_data.split(",")
		if parts.size() == 2:
			var x = parts[0].strip_edges().to_float()
			var y = parts[1].strip_edges().to_float()
			return Vector2(x, y)
		else:
			print("Invalid string format for Vector2: ", data)
	return Vector2()

# Delegiere die Verarbeitung der Bewegungsdaten an den Movement2DManager
func process_movement_data(peer_id: int, position: Vector2, velocity: Vector2):
	print("Processing movement data for peer_id ", peer_id, " Position: ", position, " Velocity: ", velocity)
	var player_movement_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "player_movement_manager")
	if player_movement_manager:
		player_movement_manager.process_received_data(peer_id, {
			"position": position,
			"velocity": velocity
		})
	else:
		print("PlayerMovement node not found.")
