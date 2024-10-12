# res://src/core/network/manager/packet_manager/handler/PacketCacheHandler.gd
extends Node

var handler_channel_cache: Dictionary = {}

# Cache the handlers for quick lookup
func cache_handler(channel: int, handler: Node):
	handler_channel_cache[channel] = handler

# Retrieve a handler by channel
func get_handler_by_channel(channel: int) -> Node:
	return handler_channel_cache.get(channel, null)

# Clear the existing cache
func clear_cache():
	handler_channel_cache.clear()

# Iterate over the channel map and cache the handlers
func cache_channel_map(channel_map: Dictionary):
	clear_cache()
	for channel in channel_map.keys():
		var handler_name = channel_map[channel]
		var handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", handler_name)
		if handler:
			cache_handler(channel, handler)
			print("Handler cached for channel: ", channel, " Handler: ", handler)
