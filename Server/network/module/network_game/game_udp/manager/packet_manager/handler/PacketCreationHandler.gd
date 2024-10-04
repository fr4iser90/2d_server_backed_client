# res://src/core/network/manager/packet_manager/handler/PacketCreationHandler.gd
extends Node

# Create a packet with a channel and data
func create_packet(handler_name: String, data: Dictionary, channel: int) -> PackedByteArray:
	var packet = {
		"channel": channel,
		"data": data
	}
	var json = JSON.new()
	return json.stringify(packet).to_utf8_buffer()
