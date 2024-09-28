# res://src/core/network/manager/packet_manager/handler/PacketDispatchHandler.gd
extends Node

var packet_manager = null
var channel_manager = null


var is_initialized = false
# Initialize the connection handler
func initialize():
	if is_initialized:
		return
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true

# Dispatch packet to the handler based on channel
func dispatch(channel: int, data: Dictionary):
	var handler = channel_manager.get_handler_for_channel(channel)
	if handler == null:
		print("No handler found for channel:", channel)
		return

	if not handler.has_method("handle_packet"):
		print("Handler missing 'handle_packet' method for channel:", channel)
		return
	#print("dispatched packet: ", data)
	handler.call("handle_packet", data)
