# res://src/core/network/module/enet_network/manager/packet_manager/handler/PacketConverterHandler.gd
extends Node

# Convert dictionary or string format to Vector2
func convert_to_vector2(data) -> Vector2:
	if data is Dictionary and data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	elif data is String:
		return _convert_from_string(data)
	else:
		print("Invalid data format for Vector2:", data)
		return Vector2.ZERO

# Helper to convert a string format "(x, y)" to Vector2
func _convert_from_string(position_string: String) -> Vector2:
	position_string = position_string.trim_prefix("(").trim_suffix(")")
	var position_data = position_string.split(",")
	if position_data.size() == 2:
		return Vector2(position_data[0].to_float(), position_data[1].to_float())
	return Vector2.ZERO

# Validate if packet contains necessary movement fields
func validate_movement_data(data: Dictionary) -> bool:
	return data.has("position") and data.has("velocity")

# General packet validation to ensure all required fields are present
func validate_packet(packet: Dictionary, required_fields: Array) -> bool:
	for field in required_fields:
		if not packet.has(field):
			print("Invalid packet structure: Missing field -", field)
			return false
	return true
