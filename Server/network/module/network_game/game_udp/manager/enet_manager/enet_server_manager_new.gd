extends Node

var channel_manager = null
var packet_manager = null
var enet_server_manager: ENetMultiplayerPeer
var connected_peers = {}  # Dictionary to track connected peers

signal enet_server_ready
signal enet_server_started

@onready var enet_server_start_handler = $Handler/ENetServerStartHandler
@onready var enet_server_stop_handler = $Handler/ENetServerStopHandler
@onready var enet_server_on_peer_connected_handler = $Handler/ENetServerOnPeerConnectedHandler
@onready var enet_server_on_peer_disconnected_handler = $Handler/ENetServerOnPeerDisconnectedHandler
@onready var enet_server_process_handler = $Handler/ENetServerProcessHandler
@onready var enet_server_packet_send_handler = $Handler/ENetServerPacketSendHandler

var is_initialized = false


func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("ENetServerManager already initialized. Skipping.", self)
		return
	GlobalManager.DebugPrint.debug_info("Initializing ENetServerManager...", self)
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	is_initialized = true
	GlobalManager.DebugPrint.debug_info("ENetServerManager initialized.", self)
	emit_signal("enet_server_ready")

# Outsourced Start Server function but with peer management in the manager
func start_server(port: int):
	if not is_initialized:
		initialize()
	print("creating ENetMultiplayerPeer")
	enet_server_manager = ENetMultiplayerPeer.new()
	# Start the server via the handler
	enet_server_start_handler.start_server(port, enet_server_manager)

# Handle peer connection event
func _on_peer_connected(peer_id: int):
	return enet_server_on_peer_connected_handler.handle_peer_connected(peer_id, connected_peers)

# Handle peer disconnection event
func _on_peer_disconnected(peer_id: int):
	return enet_server_on_peer_disconnected_handler.handle_peer_disconnected(peer_id, connected_peers)


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
	if not is_initialized:
		initialize()
	if is_instance_valid(enet_server_manager):
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
