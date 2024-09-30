# res://src/core/network/manager/packet_manager/handler/PacketProcessingHandler.gd
extends Node

# Process incoming packet and extract data
func process_packet(packet: PackedByteArray) -> Dictionary:
	var json = JSON.new()
	var result = json.parse(packet.get_string_from_utf8())  # Parse the JSON string
	if result == OK:
		return json.get_data()  # Return the extracted data
	else:
		print("Failed to parse packet: ", json.error_string)
		return {}
