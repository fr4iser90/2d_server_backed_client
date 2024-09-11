# res://src/core/network/handler/packet_handlers/player_movement_handler.gd (Client)
extends Node

var network_manager = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var handler_name = "player_movement_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		print("player_movement_handler already initialized. Skipping.")
		return
	network_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true

# Processes incoming movement data from the server
func handle_packet(data: Dictionary, sender_peer_id: int):
	if data.has("peer_id") and data.has("position") and data.has("velocity"):
		var received_peer_id = data["peer_id"]
		
		# Convert position and velocity to Vector2 if needed
		var position = _convert_to_vector2(data["position"])
		var velocity = _convert_to_vector2(data["velocity"])
		
		if position and velocity:
			print("Received movement data from peer_id ", received_peer_id, ": Position ", position, ", Velocity ", velocity)
			emit_signal("player_movement_updated", received_peer_id, position, velocity)
		else:
			print("Position or velocity data is not a Vector2 for peer_id ", received_peer_id)
			emit_signal("player_movement_failed", "Invalid data format")
	else:
		print("Invalid movement data received from server.")
		emit_signal("player_movement_failed", "Invalid data received")

func _convert_to_vector2(data) -> Vector2:
	if data is Dictionary and data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	else:
		return Vector2.ZERO  # Default value

# Sends movement data to the server
func send_movement_data(position: Vector2, velocity: Vector2):
	# Ensure initialization before proceeding
	initialize()
	
	var movement_data = {
		"position": {"x": position.x, "y": position.y},
		"velocity": {"x": velocity.x, "y": velocity.y}
	}

	var packet = {
		"handler_name": handler_name,
		"data": movement_data
	}
	
	print(packet)
	var err = enet_client_manager.send_packet(handler_name, packet)
	if err != OK:
		print("Failed to send movement data packet:", err)
	else:
		print("Movement data packet sent successfully.")
