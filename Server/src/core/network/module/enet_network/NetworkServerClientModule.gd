# res://src/core/network/manager/server_client_enet_packet_peer/manager/network_server_client_manager.gd (Server)
extends Node

var handlers = {}
var managers = {}


signal network_server_client_manager_initialized
signal network_server_client_network_started
signal network_server_client_peer_connected(peer_id: int)
signal network_server_client_peer_disconnected(peer_id: int)
signal enet_server_ready

var nodes_referenced = false
var is_connected = false
var node_init_status = {}
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	print("Initializing NetworkServerClientManager...")
	_reference_nodes()
	emit_signal("network_server_client_manager_initialized")

# Starts the client-side network server
func start_server_client_network():
	if is_connected:
		print("Server-client network is already connected.")
		return
	
	print("Starting server-client network...")
	if not nodes_referenced:
		_reference_nodes()

	_connect_signals()

	# Start the ENet server (this connects the signal to notify when it's ready)
	var enet_server_manager = managers.get("enet_server_manager")
	if enet_server_manager:
		enet_server_manager.connect("enet_server_started", Callable(self, "_on_enet_server_started"))
		enet_server_manager.start_server(GlobalManager.GlobalConfig.get_server_port())
	else:
		print("Error: ENet server manager not found.")

func _on_enet_server_started():
	print("ENet server is fully started and listening for connections.")
	var channel_manager = managers.get("channel_manager")
	var packet_manager = managers.get("packet_manager")
	
	if channel_manager:
		channel_manager.register_channel_map()
	if packet_manager:
		packet_manager.cache_channel_map()

	is_connected = true
	emit_signal("network_server_client_network_started")
	emit_signal("enet_server_ready")
	
# Reference client-side managers and handlers
func _reference_nodes():
	if nodes_referenced:
		return  # Avoid double-referencing

	print("Referencing client-side managers and handlers...")
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "network_meta_manager", managers)
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "network_handler", handlers)
	nodes_referenced = true

# Connect signals for client-side events
func _connect_signals():
	print("Connecting client-side signals...")
	var enet_server_manager = managers.get("enet_server_manager")
	if enet_server_manager:
		enet_server_manager.connect("peer_connected", Callable(self, "_on_peer_connected"))
		enet_server_manager.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
	else:
		print("Error: ENet server manager not found.")

# Handle peer connection
func _on_peer_connected(peer_id: int):
	emit_signal("network_server_client_peer_connected", peer_id)

# Handle peer disconnection
func _on_peer_disconnected(peer_id: int):
	emit_signal("network_server_client_peer_disconnected", peer_id)
