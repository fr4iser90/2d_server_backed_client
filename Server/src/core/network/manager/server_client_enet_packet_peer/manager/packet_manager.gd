# res://src/core/network/network_meta_manager/packet_manager.gd
extends Node


var channel_manager = null
var channel_map = null
var handler_channel_cache: Dictionary = {}

var is_initialized = false  


func initialize():
	if is_initialized:
		return
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	channel_map = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_map")
	is_initialized = true
	
# Ready function to initialize
func _ready():
	if not is_initialized:
		initialize()

# Cache the global channel map and store handlers
func cache_channel_map():
	# Clear the existing handler cache
	handler_channel_cache.clear()
	# Iterate through the global channel map and cache the handlers
	for channel in channel_map.CHANNEL_MAP.keys():
		var handler_name = channel_map.CHANNEL_MAP[channel]
		#var handler = GlobalManager.NodeManager.reference_map_entry("NetworkHandlerMap", "network_handler", handler_name)
		var handler = GlobalManager.NodeManager.get_cached_node("network_handler_map", handler_name)
		#var handler = GlobalManager.NodeManager.get_cached_node("handlers", handler_name)
		if handler:
			handler_channel_cache[channel] = handler
			print("Handler cached for channel: ", channel, "Handler:", handler)
	#print("Channel map cached:", handler_channel_cache)

# Create a packet with a channel, resolving the channel based on the handler name
func create_packet_for_handler(handler_name: String, data: Dictionary) -> PackedByteArray:
	var channel = -1  
	# Check if the handler's channel is already cached
	if handler_channel_cache.has(handler_name):
		channel = handler_channel_cache[handler_name]
	else:
		# If not cached, look up the channel
		channel = channel_manager.get_channel_for_handler(handler_name)
		if channel == -1:
			print("Error: No valid channel for handler:", handler_name)
			return PackedByteArray()  # Return an empty PackedByteArray instead of null
		# Cache the channel for future lookups
		handler_channel_cache[handler_name] = channel

	# Create and return the packet
	var packet = {
		"channel": channel,
		"data": data
	}
	var json = JSON.new()
	return json.stringify(packet).to_utf8_buffer()

# Process incoming packet
func process_incoming_packet(packet: PackedByteArray) -> Dictionary:
	var json = JSON.new()
	var result = json.parse(packet.get_string_from_utf8())  # Parse the JSON string
	if result == OK:
		var packet_data = json.get_data()  # Get the parsed data from the JSON object
		return packet_data
	else:
		print("Failed to parse packet: ", json.error_string)
		return {}

# Handle an incoming packet
func process_packet(packet: PackedByteArray, peer_id: int):
	var packet_data = process_incoming_packet(packet)

	if packet_data.size() == 0:
		print("Failed to process packet from peer_id:", peer_id)
		return

	var channel = int(packet_data.get("channel", -1))
	var data = packet_data.get("data", null)

	if channel == -1 or data == null:
		print("Invalid packet structure from peer_id:", peer_id, "Channel:", channel)
		return

	# Get the handler from the local cache
	var handler = handler_channel_cache.get(channel, null)
	print("Retrieved handler for channel ", channel, ":", handler)

	if handler == null:
		print("No handler registered for channel: ", channel, "from peer_id:", peer_id)
		return

	if not handler.has_method("handle_packet"):
		print("Handler for channel: ", channel, " is missing 'handle_packet' method, peer_id: ", peer_id)
		return

	handler.call("handle_packet", data, peer_id)
