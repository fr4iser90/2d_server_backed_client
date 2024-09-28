# res://src/core/network/handler/packet_handlers/player_movement_handler.gd (Client)
extends Node

var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var packet_converter_handler = null
var packet_validation_handler = null
var handler_name = "movement_player_handler"
var is_initialized = false

# Initialize the handler and manager nodes
func initialize():
	if is_initialized:
		print("player_movement_handler already initialized. Skipping.")
		return

	enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	packet_converter_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_converter_handler")
	packet_validation_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_validation_handler")
	is_initialized = true

# Processes incoming movement data from the server
func handle_packet(data: Dictionary):
	# Validate packet data using packet_validation_handler
	# we still handle our movement then in our handler i think 
	pass

# Sends movement data to the server
func send_movement_data(position: Vector2, velocity: Vector2, additional_data: Dictionary = {}):
	var movement_data = {
		"position": {"x": position.x, "y": position.y},
		"velocity": {"x": velocity.x, "y": velocity.y}
	}
	# Add modular data from additional_data if provided
	for key in additional_data.keys():
		movement_data[key] = additional_data[key]

	print("Sending movement data: ", movement_data)
	var err = enet_client_manager.send_packet(handler_name, movement_data)
	if err != OK:
		print("Failed to send movement data packet:", err)
	else:
		print("Movement data packet sent successfully.")
