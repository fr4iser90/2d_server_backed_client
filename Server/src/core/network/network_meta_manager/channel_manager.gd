# res://src/core/network/manager/channel_manager.gd (Server)
extends Node

var handlers = {}  # Stores registered handlers
var handler_channel_cache: Dictionary = {}
var global_channel_map = null
var packet_manager

var is_initialized = false  

# Initialisiere den Manager nur einmal
func initialize():
	if is_initialized:
		return
	is_initialized = true
	global_channel_map = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "global_channel_map")

	
# Funktion zur Registrierung der globalen Kanalzuordnung 
func register_global_channel_map():
	if global_channel_map:
		auto_register_handlers(global_channel_map.GLOBAL_CHANNEL_MAP)
	else:
		print("Error: global_channel_map ist null")

# Automatische Registrierung der Handler basierend auf der Kanalzuordnung
func auto_register_handlers(channel_map: Dictionary):
	for channel in channel_map.keys():
		var handler_name = channel_map[channel]
		# Dynamisch die Handler-Node basierend auf dem Namen suchen
		var handler = GlobalManager.GlobalNodeManager.get_cached_node("handlers", handler_name)
		if handler != null:
			register_handler(channel, handler)
		else:
			#print("Warning: Kein Handler gefunden für Kanal ", channel, "->", handler_name)
			pass

# Funktion zur Registrierung eines Handlers für einen spezifischen Kanal
func register_handler(channel: int, handler: Node):
	if handler == null:
		print("Error: Handler ist null für Kanal " + str(channel))
		return
	handlers[channel] = handler
	print("Handler registered for channel: ", channel, " ", handler)


		
# Function to get the channel for a specific handler
func get_channel_for_handler(handler_name: String) -> int:
	if global_channel_map:
		# Access the GLOBAL_CHANNEL_MAP constant from the node script
		var channel_map = global_channel_map.get("GLOBAL_CHANNEL_MAP")  # Access the constant using `get`
		if channel_map:
			for channel in channel_map.keys():
				if channel_map[channel] == handler_name:
					return channel
			print("Error: No valid channel found for handler:", handler_name)
		else:
			print("Error: GLOBAL_CHANNEL_MAP not found in the node.")
	else:
		print("Error: No valid global channel map node found.")
		
	return -1  # Return an invalid channel if not found
