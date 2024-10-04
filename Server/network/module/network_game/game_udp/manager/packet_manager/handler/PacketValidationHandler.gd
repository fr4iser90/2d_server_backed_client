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
func validate_movement_packet(packet: Dictionary) -> bool:
	var required_fields = ["channel", "data", "position", "velocity"]
	return validate_packet(packet, required_fields)

# You can also add type checks to ensure packet data types are correct
