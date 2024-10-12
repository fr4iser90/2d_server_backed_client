# res://src/core/network/network_meta_manager/packet_manager.gd
extends Node

var packet_creation_handler = null
var packet_processing_handler = null
var packet_dispatch_handler = null
var packet_cache_handler = null
var channel_manager = null
var channel_map = null

var is_initialized = false


# Initialize all handlers
func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("PacketManager already initialized. Skipping.", self)
		return
	
	packet_creation_handler = GlobalManager.NodeManager.get_cached_node("NetworkPacketManager", "PacketCreationHandler")
	packet_processing_handler = GlobalManager.NodeManager.get_cached_node("NetworkPacketManager", "PacketProcessingHandler")
	packet_dispatch_handler = GlobalManager.NodeManager.get_cached_node("NetworkPacketManager", "PacketDispatchHandler")
	packet_cache_handler = GlobalManager.NodeManager.get_cached_node("NetworkPacketManager", "PacketCacheHandler")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	channel_map = GlobalManager.NodeManager.get_cached_node("NetworkChannelManager", "ChannelMap")
	is_initialized = true

# Create a packet for the specified handler
func create_packet_for_handler(handler_name: String, data: Dictionary) -> PackedByteArray:
	var channel = channel_manager.get_channel_for_handler(handler_name)
	if channel == -1:
		GlobalManager.DebugPrint.debug_error("Error: No valid channel for handler: " + handler_name, self)
		return PackedByteArray()
	
	GlobalManager.DebugPrint.debug_info("Creating packet for handler: " + handler_name, self)
	return packet_creation_handler.create_packet(handler_name, data, channel)

# Process incoming packet and delegate it to the dispatcher
func process_packet(packet: PackedByteArray, peer_id: int):
	var packet_data = packet_processing_handler.process_packet(packet)
	if packet_data.size() == 0:
		GlobalManager.DebugPrint.debug_error("Failed to process packet from peer_id: " + str(peer_id), self)
		return

	var channel = int(packet_data.get("channel", -1))
	var data = packet_data.get("data", null)

	if channel == -1 or data == null:
		GlobalManager.DebugPrint.debug_error("Invalid packet structure from peer_id: " + str(peer_id), self)
		return

	GlobalManager.DebugPrint.debug_info("Processing packet for channel: " + str(channel) + " and peer_id: " + str(peer_id), self)
	packet_dispatch_handler.dispatch(channel, data, peer_id)

# Cache the channel map from the channel manager
func cache_channel_map():
	if channel_map.CHANNEL_MAP != null:
		var channel_map_dict = channel_map.CHANNEL_MAP
		packet_cache_handler.cache_channel_map(channel_map_dict)
		GlobalManager.DebugPrint.debug_info("Channel map cached successfully.", self)
	else:
		GlobalManager.DebugPrint.debug_error("Error: CHANNEL_MAP not found in channel_map.", self)

