# res://src/core/network/manager/server_client_enet_packet_peer/handler/movement_player_handler.gd (Server)
extends Node

var enet_server_manager
var player_movement_manager
var movement_player_sync_handler
var instance_manager
var packet_converter_handler  # Reference to the PacketConverterHandler
var handler_name = "movement_player_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		print("PlayerMovementHandler already initialized. Skipping.")
		return
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	movement_player_sync_handler = GlobalManager.NodeManager.get_cached_node("network_handler", "movement_player_sync_handler")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	packet_converter_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_converter_handler")  # Importing the converter
	is_initialized = true

# Handle incoming packets for player movement
func handle_packet(data: Dictionary, peer_id: int):
	# Extract position and velocity from the inner dictionary
	var position = data.get("position", null)
	var velocity = data.get("velocity", null)

	# Debugging extracted position and velocity
	print("Extracted position: ", position, " and velocity: ", velocity, " for peer_id: ", peer_id)

	# Convert position and velocity using the PacketConverterHandler
	var position_converted = packet_converter_handler.convert_to_vector2(position)
	var velocity_converted = packet_converter_handler.convert_to_vector2(velocity)

	# Debugging converted position and velocity
	print("Converted position: ", position_converted, " and velocity: ", velocity_converted, " for peer_id: ", peer_id)

	# Validate the data using PacketConverterHandler and process it
	if packet_converter_handler.validate_movement_data(data):
		print("Valid movement data for peer_id: ", peer_id, ". Processing movement...")
		process_movement_data(peer_id, position_converted, velocity_converted, data)
	else:
		print("Invalid position or velocity for peer_id ", peer_id, ": position = ", position_converted, ", velocity = ", velocity_converted)


# Process received movement data and forward to all clients in the same instance
func process_movement_data(peer_id: int, position: Vector2, velocity: Vector2, additional_data: Dictionary):
	if player_movement_manager:
		player_movement_manager.process_received_data(peer_id, {
			"position": position,
			"velocity": velocity,
			"additional_data": additional_data  # Modular additional data
		})
		# Update the instance_manager with the new position
#		var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
#		if instance_key != "":
#			var instance_data = instance_manager.get_instance_data(instance_key)
#			if instance_data and instance_data.has("players"):
#				# Update the last_known_position for the peer_id in the instance
#				for player_data in instance_data["players"]:
#					if player_data["peer_id"] == peer_id:
#						player_data["position"] = position
#						player_data["velocity"] = velocity
#						print("Updated PositionData for peer_id: ", peer_id, " to position: ", position, " and velocity: ", velocity)

		# Broadcast movement data to all clients in the same instance
		movement_player_sync_handler.sync_positions_with_clients_in_instance(peer_id, {
			"position": position,
			"velocity": velocity,
			"additional_data": additional_data
		})
	else:
		print("PlayerMovementManager node not found.")
