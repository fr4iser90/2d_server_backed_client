# res://src/core/network/server_client/manager/network_server_client_manager.gd
extends Node

# Managers and Handlers specific to client-side
var node_config_manager = null
var handlers = {}
var managers = {}

signal network_server_client_manager_initialized
signal network_server_client_network_started
signal network_server_client_connection_established
signal network_server_client_peer_connected(peer_id: int)
signal network_server_client_peer_disconnected(peer_id: int)
signal enet_server_ready

var is_initialized = false
var is_connected = false
var node_init_status = {}

func _ready():
	if not is_initialized:
		print("Initializing NetworkServerClientManager...")
		_reference_nodes()
		emit_signal("network_server_client_manager_initialized")
	else:
		print("ClientManager already initialized.")

# Starts the client-side network server
func start_server_client_network():
	print("called starter server client network")
	if is_connected:
		print("Server-client network is already connected.")
		return
	
	print("Starting server-client network...")
	_reference_nodes()
	_connect_signals()

	# Start the ENet server (this connects the signal to notify when it's ready)
	var enet_server_manager = managers.get("enet_server_manager")
	if enet_server_manager:
		enet_server_manager.connect("enet_server_started", Callable(self, "_on_enet_server_started"))
		enet_server_manager.start_server(GlobalManager.GlobalConfig.get_server_port())

	# Set connected flag to true
	is_connected = true
	emit_signal("network_server_client_network_started")

func _on_enet_server_started():
	print("ENet server is fully started and listening for connections.")
	emit_signal("enet_server_ready")
	
# Reference client-side managers and handlers
func _reference_nodes():
	print("Referencing client-side managers and handlers...")
	node_config_manager = GlobalManager.GlobalNodeManager.get_node_from_config("global_node_manager", "node_config_manager")
	_reference_entities("network_meta_manager", GlobalManager.GlobalNodeManager.node_config_manager.network_meta_manager, managers)
	_reference_entities("network_handler", GlobalManager.GlobalNodeManager.node_config_manager.network_handler, handlers)
	#_reference_entities("gameplay_manager", GlobalManager.GlobalNodeConfig.gameplay_manager, managers)
	
	
# Helper to reference entities (common structure)
func _reference_entities(node_type: String, paths: Dictionary, target: Dictionary):
	for key in paths.keys():
		var node = GlobalManager.GlobalNodeManager.get_node_from_config(node_type, key)
		if node:
			target[key] = node
			print("Referenced: " + key)
		else:
			print("Error: Could not reference " + key)

# Connect signals for client-side events
func _connect_signals():
	print("Connecting client-side signals...")
	var enet_server_manager = managers.get("enet_server_manager")
	if enet_server_manager == null:
		print("Error: enet_server_manager not found.")
		return
	
	enet_server_manager.connect("peer_connected", Callable(self, "_on_peer_connected"))
	enet_server_manager.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))

# Handle peer connection
func _on_peer_connected(peer_id: int):
	emit_signal("network_manager_peer_connected", peer_id)

# Handle peer disconnection
func _on_peer_disconnected(peer_id: int):
	emit_signal("network_manager_peer_disconnected", peer_id)
