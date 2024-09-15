# res://src/core/network/manager/channel_manager.gd (Server)
extends Node

var handlers = {}  # Stores registered handlers
var handler_channel_cache: Dictionary = {}
var channel_map
var packet_manager

var is_initialized = false  

# Initialisiere den Manager nur einmal
func initialize():
	if is_initialized:
		return
	is_initialized = true
	channel_map = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_map")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	
# Funktion zur Registrierung der globalen Kanalzuordnung 
func register_channel_map():
	var channel_map = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_map")
	if channel_map:
		auto_register_handlers(channel_map.CHANNEL_MAP)
	else:
		print("Error: channel_map ist null")

# Automatische Registrierung der Handler basierend auf der Kanalzuordnung
func auto_register_handlers(channel_map_dic: Dictionary):
	for channel in channel_map_dic.keys():
		var handler_name = channel_map_dic[channel]
		# Dynamisch die Handler-Node basierend auf dem Namen suchen
		#var handler = GlobalManager.NodeManager.reference_map_entry("NetworkHandlerMap", "network_handler", handler_name)
		var handler = GlobalManager.NodeManager.get_cached_node("network_handler_map", handler_name)
		#var	handler = GlobalManager.NodeManager.get_node_from_config("network_handler_map", handler_name)
		if handler != null:
			register_handler(channel, handler)
		else:
			#print("Warning: Kein Handler gefunden für Kanal ", channel, "->", handler_name)
			pass

# Funktion zur Registrierung eines Handlers für einen spezifischen Kanal
func register_handler(channel: int, handler: Node):
	if handler == null:
		#print("Error: Handler ist null für Kanal " + str(channel))
		return
	handlers[channel] = handler
	print("Handler registered for channel: ", channel, " ", handler)

		
# Function to get the channel for a specific handler
func get_channel_for_handler(handler_name: String) -> int:
	if channel_map:
		# Access the CHANNEL_MAP constant from the node script
		var channel_map_dict = channel_map.get("CHANNEL_MAP")  # Access the constant using `get`
		if channel_map_dict:
			for channel in channel_map_dict.keys():
				if channel_map_dict[channel] == handler_name:
					return channel
			#print("Error: No valid channel found for handler:", handler_name)
		else:
			print("Error: CHANNEL_MAP not found in the node.")
	else:
		print("Error: No valid global channel map node found.")
		
	return -1  # Return an invalid channel if not found
