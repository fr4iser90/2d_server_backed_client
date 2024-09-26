# res://src/core/network/module/enet_network/manager/packet_manager/handler/PacketValidationHandler.gd
extends Node

# Ensure that the packet contains the necessary fields before processing
func validate_packet(packet: Dictionary, required_fields: Array) -> bool:
	for field in required_fields:
		if not packet.has(field):
			print("Invalid packet structure: Missing field - ", field)
			return false
	return true

# Example validation for a movement packet
func validate_movement_data(movement_data: Dictionary) -> bool:
	# Check if movement_data contains both position and velocity
	if movement_data.has("position") and movement_data.has("velocity"):
		return true
	print("Validation failed: Movement data is missing position or velocity.")
	return false
