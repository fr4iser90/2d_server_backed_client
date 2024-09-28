extends Node

var channel_manager = null
var packet_manager = null
var enet_server_manager
var connected_peers = {}  # Dictionary to track connected peers
signal peer_connected(peer_id: int)
signal peer_disconnected(peer_id: int)
signal enet_server_ready
signal enet_server_started

var is_initialized = false
var debug_enabled = true

func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("ENetServerManager already initialized. Skipping.", self)
		return
	GlobalManager.DebugPrint.set_debug_level(GlobalManager.DebugPrint.DebugLevel.WARNING)
	GlobalManager.DebugPrint.set_debug_enabled(debug_enabled)
	GlobalManager.DebugPrint.debug_info("Initializing ENetServerManager...", self)
	
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	is_initialized = true
	GlobalManager.DebugPrint.debug_info("ENetServerManager initialized.", self)
	emit_signal("enet_server_ready")

func start_server(port: int):
	if not is_initialized:
		initialize()
	enet_server_manager = ENetMultiplayerPeer.new()
	var err = enet_server_manager.create_server(port, 32)
	if err == OK:
		var server_peer_id = enet_server_manager.get_unique_id()
		GlobalManager.DebugPrint.debug_info("Server listening on port " + str(port) + " | Server Peer ID: " + str(server_peer_id), self)
		enet_server_manager.connect("peer_connected", Callable(self, "_on_peer_connected"))
		enet_server_manager.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
		set_process(true)  # Ensure _process is called every frame
		is_initialized = true
		emit_signal("enet_server_started")
	else:
		GlobalManager.DebugPrint.debug_error("Failed to start server: " + str(err), self)
		set_process(false)

# Called when a peer connects
func _on_peer_connected(peer_id: int):
	GlobalManager.DebugPrint.debug_info("Peer connected with ID: " + str(peer_id), self)
	connected_peers[peer_id] = true  # Register the peer as connected
	emit_signal("peer_connected", peer_id)
	
	var core_connection_handler = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "core_connection_handler")
	if core_connection_handler:
		core_connection_handler.handle_connection_request(peer_id)

# Called when a peer disconnects
# Called when a peer disconnects
func _on_peer_disconnected(peer_id: int):
	GlobalManager.DebugPrint.debug_info("Peer disconnected with ID: " + str(peer_id), self)
	connected_peers.erase(peer_id)  # Remove the peer from the connected list
	
	# Liste von Managern, die die Peer-ID löschen müssen
	var manager_list = [
		{"manager": "world_manager", "node": "instance_manager", "remove_function": "remove_player_from_instance"},
		{"manager": "game_manager", "node": "player_movement_manager", "remove_function": "remove_player"},
		{"manager": "user_manager", "node": "user_session_manager", "remove_function": "remove_user"},
		{"manager": "game_manager", "node": "character_manager", "remove_function": "remove_character"}
	]

	# Iteriere durch die Liste und entferne die Peer-ID dynamisch
	for manager_data in manager_list:
		var manager = GlobalManager.NodeManager.get_cached_node(manager_data["manager"], manager_data["node"])
		if manager and manager.has_method(manager_data["remove_function"]):
			manager.call(manager_data["remove_function"], peer_id)
			GlobalManager.DebugPrint.debug_info(manager_data["remove_function"] + " called for " + manager_data["node"] + " with peer_id: " + str(peer_id), self)
		else:
			GlobalManager.DebugPrint.debug_warning("Manager or function not found: " + manager_data["node"], self)
	
	emit_signal("peer_disconnected", peer_id)


func _process(delta):
	if enet_server_manager:
		enet_server_manager.poll()
		while enet_server_manager.get_available_packet_count() > 0:
			var peer_id = enet_server_manager.get_packet_peer()  # Get the peer ID from the packet
			var packet = enet_server_manager.get_packet()  # Retrieve the packet
			if connected_peers.has(peer_id):
				# Process the packet for the correct peer
				GlobalManager.DebugPrint.debug_info("Processing packet from peer_id: " + str(peer_id), self)
				packet_manager.process_packet(packet, peer_id)
			else:
				GlobalManager.DebugPrint.debug_warning("Unknown or invalid peer_id: " + str(peer_id), self)

# Modified send_packet function without the need to pass the handler name explicitly
func send_packet(peer_id: int, handler_name: String, data: Dictionary) -> int:
	if is_instance_valid(enet_server_manager):
		packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
		var packet = packet_manager.create_packet_for_handler(handler_name, data)

		if packet.size() == 0:
			GlobalManager.DebugPrint.debug_error("Failed to create packet for handler: " + handler_name, self)
			return ERR_INVALID_PARAMETER

		enet_server_manager.set_target_peer(peer_id)
		var err = enet_server_manager.put_packet(packet)
		if err != OK:
			GlobalManager.DebugPrint.debug_error("Failed to send packet: " + str(err), self)
			return err

		return OK
	else:
		GlobalManager.DebugPrint.debug_error("ENet server instance is not valid, cannot send packet.", self)
		return ERR_INVALID_PARAMETER

# Function to get the peer (for access in other scripts)
func get_peer() -> ENetMultiplayerPeer:
	return enet_server_manager
