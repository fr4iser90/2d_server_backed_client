# res://src/core/network/manager/ClientServerManager.gd (Client)
extends Node

var handlers = {}
var managers = {}

signal network_module_connected_to_server
signal network_module_disconnected_from_server
signal network_module_connection_failed
signal enet_peer_ready

var nodes_referenced = false
var is_connected = false
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	print("Initializing Client NetworkManager... Using UDP ENetMultiplayerPeer library.")
	_reference_nodes()
	
	
# Connects to the server
func connect_to_server():
	# Stelle sicher, dass der NetworkModule initialisiert ist
	if not is_initialized:
		initialize()

	_reference_nodes()
	_connect_signals()
	
	if is_connected:
		print("Client is already connected.")
		return
	
	var enet_client_manager = managers.get("NetworkENetClientManager")
	if enet_client_manager:
		enet_client_manager.create_client_peer()
	else:
		print("Error: ENet client manager not found.")

# Reference managers and handlers
func _reference_nodes():
	if nodes_referenced:
		return	
	print("Referencing managers and handlers...")
	GlobalManager.NodeManager.reference_map_entry("GlobalNodeMap", "NetworkGameModule", managers)
	GlobalManager.NodeManager.reference_map_entry("GlobalNodeMap", "NetworkGameModuleService", handlers)
	nodes_referenced = true

# Connect signals for client events
func _connect_signals():
	var enet_client_manager = managers.get("NetworkENetClientManager")
	if enet_client_manager:
		enet_client_manager.connect("enet_client_manager_created_client", Callable(self, "_on_client_created"))
		enet_client_manager.connect("disconnected_from_server", Callable(self, "_on_disconnected"))
		enet_client_manager.connect("connection_failed", Callable(self, "_on_connection_failed"))
	else:
		print("Error: ENet client manager not found.")

# Signal callback methods
func _on_client_created():
	is_connected = true
	emit_signal("network_module_connected_to_server")

func _on_disconnected():
	is_connected = false
	emit_signal("network_module_disconnected_from_server")

func _on_connection_failed():
	is_connected = false
	emit_signal("network_module_connection_failed")
