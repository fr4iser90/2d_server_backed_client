extends Node

var handlers = {}  # Stores registered handlers
var handler_channel_cache: Dictionary = {}
var channel_map
var packet_manager

var is_initialized = false


func _ready():
	initialize()

# Initialisiere den Manager nur einmal
func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("ChannelManager already initialized. Skipping.", self)
		return
	GlobalManager.DebugPrint.debug_info("Initializing ChannelManager...", self)

	channel_map = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_channel_map")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_packet_manager")
	
	GlobalManager.DebugPrint.debug_info("ChannelManager initialized.", self)
	is_initialized = true
	
# Funktion zur Registrierung der globalen Kanalzuordnung 
func register_channel_map():
	if not is_initialized:
		initialize()
	var channel_map = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_channel_map")
	if channel_map:
		auto_register_handlers(channel_map.CHANNEL_MAP)
	else:
		GlobalManager.DebugPrint.debug_error("Error: channel_map is null.", self)

# Automatische Registrierung der Handler basierend auf der Kanalzuordnung
func auto_register_handlers(channel_map_dic: Dictionary):
	if not is_initialized:
		initialize()
	for channel in channel_map_dic.keys():
		var handler_name = channel_map_dic[channel]
		var handler = GlobalManager.NodeManager.get_cached_node("network_game_handler", handler_name)
		if handler != null:
			register_handler(channel, handler)
		else:
			GlobalManager.DebugPrint.debug_info("Info/Warning: No handler found for channel " + str(channel) + " -> " + handler_name, self)

# Funktion zur Registrierung eines Handlers für einen spezifischen Kanal
func register_handler(channel: int, handler: Node):
	if not is_initialized:
		initialize()
	if handler == null:
		GlobalManager.DebugPrint.debug_error("Error: Handler is null for channel " + str(channel), self)
		return
	handlers[channel] = handler
	GlobalManager.DebugPrint.debug_info("Handler registered for channel: " + str(channel) + " " + str(handler), self)

# Function to get the channel for a specific handler
func get_channel_for_handler(handler_name: String) -> int:
	if not is_initialized:
		initialize()
	if channel_map:
		var channel_map_dict = channel_map.get("CHANNEL_MAP")  # Access the constant using `get`
		if channel_map_dict:
			for channel in channel_map_dict.keys():
				if channel_map_dict[channel] == handler_name:
					return channel
			GlobalManager.DebugPrint.debug_error("Error: No valid channel found for handler: " + handler_name, self)
		else:
			GlobalManager.DebugPrint.debug_error("Error: CHANNEL_MAP not found in the node.", self)
	else:
		GlobalManager.DebugPrint.debug_error("Error: No valid global channel map node found.", self)
		
	return -1  # Return an invalid channel if not found

# Function to get the handler for a specific channel
func get_handler_for_channel(channel: int) -> Node:
	if not is_initialized:
		initialize()
	if handlers.has(channel):
		return handlers[channel]
	else:
		GlobalManager.DebugPrint.debug_error("Error: No handler found for channel " + str(channel), self)
		return null
