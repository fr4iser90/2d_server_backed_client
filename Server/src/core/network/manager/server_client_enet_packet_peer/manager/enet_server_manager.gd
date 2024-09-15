# res://src/core/network/enet_server_manager.gd (Server)
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

func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	packet_manager = GlobalManager.NodeManager.get_node_from_config("network_meta_manager", "packet_manager")
	channel_manager = GlobalManager.NodeManager.get_node_from_config("network_meta_manager", "channel_manager")
	is_initialized = true
	print("ENetServerManager initialized.")
	emit_signal("enet_server_ready")
	
func start_server(port: int):
	enet_server_manager = ENetMultiplayerPeer.new()
	var err = enet_server_manager.create_server(port, 32)
	if err == OK:
		var server_peer_id = enet_server_manager.get_unique_id()
		print("Server listening on port ", port, " | Server Peer ID: ", server_peer_id)
		enet_server_manager.connect("peer_connected", Callable(self, "_on_peer_connected"))
		enet_server_manager.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
		set_process(true)  # Ensure _process is called every frame
		is_initialized = true
		emit_signal("enet_server_started")
	else:
		print("Failed to start server: ", err)
		set_process(false)

# Diese Funktion wird aufgerufen, wenn sich ein Peer verbindet
func _on_peer_connected(peer_id: int):
	print("Peer connected with ID: ", peer_id)
	connected_peers[peer_id] = true  # Registriere den Peer als verbunden
	emit_signal("peer_connected", peer_id)

# Diese Funktion wird aufgerufen, wenn sich ein Peer trennt
func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected with ID: ", peer_id)
	connected_peers.erase(peer_id)  # Entferne den Peer aus der lokalen Liste
	print("Updated connected peers: ", connected_peers)
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	if user_session_manager:
		user_session_manager.remove_user(peer_id)
	emit_signal("peer_disconnected", peer_id)

func _process(delta):
	if enet_server_manager:
		enet_server_manager.poll()
		while enet_server_manager.get_available_packet_count() > 0:
			print("Packet available!")
			var packet = enet_server_manager.get_packet()  # Paket zuerst abholen
			print("Connected peers: ", connected_peers)
			for peer_id in connected_peers.keys():
				if connected_peers[peer_id]:
					print("Packet received from peer_id: ", peer_id)
					packet_manager.process_packet(packet, peer_id)
				else:
					print("Unknown or invalid peer_id.")

# Modified send_packet function without the need to pass the handler name explicitly
func send_packet(peer_id: int, handler_name: String, data: Dictionary) -> int:
	if is_instance_valid(enet_server_manager):
		print("Sending packet to peer:", peer_id)

		# Use packet_channel_manager to create the packet with the appropriate channel
		var packet = packet_manager.create_packet_for_handler(handler_name, data)

		# Check if packet creation was successful
		if packet.size() == 0:
			print("Failed to create packet for handler:", handler_name)
			return ERR_INVALID_PARAMETER

		# Set the target peer and send the packet
		enet_server_manager.set_target_peer(peer_id)
		var err = enet_server_manager.put_packet(packet)
		if err != OK:
			print("Failed to send packet:", err)
			return err
		return OK
	else:
		print("ENet server instance is not valid, cannot send packet.")
		return ERR_INVALID_PARAMETER


# Funktion zum Abrufen des Peers (für den Zugriff in anderen Skripten)
func get_peer() -> ENetMultiplayerPeer:
	return enet_server_manager
