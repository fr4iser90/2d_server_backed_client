# res://src/core/network/manager/packet_manager/handler/PacketDispatchHandler.gd
extends Node

var packet_manager = null
var channel_manager = null

var is_initialized = false


# Initialize the connection handler
func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_warning("PacketDispatchHandler already initialized. Skipping.", self)
		return
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	is_initialized = true

# Dispatch packet to the handler based on channel
func dispatch(channel: int, data: Dictionary, peer_id: int):
	# Find the handler for the channel
	var handler = channel_manager.get_handler_for_channel(channel)
	if handler == null:
		GlobalManager.DebugPrint.debug_warning("No handler found for channel: " + str(channel), self)
		return

	# Check if the handler has the method to process the packet
	if not handler.has_method("handle_packet"):
		GlobalManager.DebugPrint.debug_warning("Handler missing 'handle_packet' method for channel: " + str(channel), self)
		return

	# Log the dispatch process
	GlobalManager.DebugPrint.debug_info("Dispatching packet for channel: " + str(channel) + " for peer_id: " + str(peer_id), self)
	handler.call("handle_packet", data, peer_id)
