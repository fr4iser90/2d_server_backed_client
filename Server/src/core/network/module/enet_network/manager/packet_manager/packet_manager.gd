# res://src/core/network/network_meta_manager/packet_manager.gd
extends Node

var packet_creation_handler = null
var packet_processing_handler = null
var packet_dispatch_handler = null
var packet_cache_handler = null
var channel_manager = null
var channel_map = null

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	packet_creation_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_creation_handler")
	packet_processing_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_processing_handler")
	packet_dispatch_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_dispatch_handler")
	packet_cache_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_cache_handler")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	channel_map = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_map")
	is_initialized = true

# Create packet for handler
func create_packet_for_handler(handler_name: String, data: Dictionary) -> PackedByteArray:
	var channel = channel_manager.get_channel_for_handler(handler_name)
	if channel == -1:
		print("Error: No valid channel for handler:", handler_name)
		return PackedByteArray()
	
	return packet_creation_handler.create_packet(handler_name, data, channel)

# Process incoming packet and delegate to the dispatcher
func process_packet(packet: PackedByteArray, peer_id: int):
	var packet_data = packet_processing_handler.process_packet(packet)
	if packet_data.size() == 0:
		print("Failed to process packet from peer_id:", peer_id)
		return

	var channel = int(packet_data.get("channel", -1))
	var data = packet_data.get("data", null)

	if channel == -1 or data == null:
		print("Invalid packet structure from peer_id:", peer_id)
		return

	# Dispatch the packet
	packet_dispatch_handler.dispatch(channel, data, peer_id)

func cache_channel_map():
	# Überprüfe, ob `channel_map` eine Konstante `CHANNEL_MAP` hat und rufe sie direkt ab
	if channel_map.CHANNEL_MAP != null:
		var channel_map_dict = channel_map.CHANNEL_MAP  # Holen der CHANNEL_MAP-Konstanten als Dictionary
		packet_cache_handler.cache_channel_map(channel_map_dict)  # Übergib es an den CacheHandler
	else:
		print("Error: CHANNEL_MAP nicht in channel_map gefunden")


