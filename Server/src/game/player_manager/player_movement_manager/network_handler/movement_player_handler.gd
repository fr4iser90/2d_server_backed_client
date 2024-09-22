# res://src/core/network/manager/server_client_enet_packet_peer/handler/movement_player_handler.gd (Server)
extends Node

var enet_server_manager
var player_movement_manager
var movement_player_sync_handler
var handler_name = "movement_player_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		print("PlayerMovementHandler already initialized. Skipping.")
		return
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	movement_player_sync_handler = GlobalManager.NodeManager.get_cached_node("network_handler", "movement_player_sync_handler")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	is_initialized = true

# Handle incoming packets for player movement
func handle_packet(data: Dictionary, peer_id: int):
	# Access the inner data dictionary first
	var movement_data = data.get("data", null)
	
	if movement_data == null:
		print("No movement data found in packet for peer_id: ", peer_id)
		return
	
	# Extract position and velocity from the inner dictionary
	var position = movement_data.get("position", null)
	var velocity = movement_data.get("velocity", null)
	# Convert position and velocity
	var position_converted = _convert_to_vector2(position)
	var velocity_converted = _convert_to_vector2(velocity)

	# Debugging: Print the raw data
	#print("Received raw data: ", data)
	#print("Received raw data position: ", position)
	#print("Received raw data velocity: ", velocity)
	#print("Converted Position: ", position_converted, " Type: ", typeof(position))
	#print("Converted Velocity: ", velocity_converted, " Type: ", typeof(velocity))
	
	# Validate the data and process it
	if _validate_movement_data(position_converted, velocity_converted):
		process_movement_data(peer_id, position_converted, velocity_converted, data)
	else:
		print("Invalid position or velocity for peer_id ", peer_id)

# Converts incoming data to Vector2
func _convert_to_vector2(data) -> Vector2:
	# Check if data is a Dictionary and has x and y keys
	if data is Dictionary and data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	# In case data is passed as a string (e.g., "(x, y)")
	elif data is String:
		var cleaned_data = data.replace("(", "").replace(")", "")
		var parts = cleaned_data.split(",")
		if parts.size() == 2:
			var x = parts[0].strip_edges().to_float()
			var y = parts[1].strip_edges().to_float()
			return Vector2(x, y)
	else:
		print("Invalid data format for Vector2: ", data)
	return Vector2.ZERO

# Validates basic movement data (Position and Velocity)
func _validate_movement_data(position: Vector2, velocity: Vector2) -> bool:
	if position == Vector2.ZERO or velocity == Vector2.ZERO:
		return false
	return true

# Process received movement data and forward to all clients in the same instance
func process_movement_data(peer_id: int, position: Vector2, velocity: Vector2, additional_data: Dictionary):
	
	if player_movement_manager:
		player_movement_manager.process_received_data(peer_id, {
			"position": position,
			"velocity": velocity,
			"additional_data": additional_data  # Modular additional data
		})
		# Broadcast movement data to all clients in the same instance
		movement_player_sync_handler.sync_positions_with_clients_in_instance(peer_id, {
			"position": position,
			"velocity": velocity,
			"additional_data": additional_data
		})
	else:
		print("PlayerMovementManager node not found.")
