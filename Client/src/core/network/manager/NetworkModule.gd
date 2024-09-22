# res://src/core/network/manager/NetworkModule.gd (Client)
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
	
	var enet_client_manager = managers.get("enet_client_manager")
	if enet_client_manager:
		enet_client_manager.create_client_peer()
	else:
		print("Error: ENet client manager not found.")

# Reference managers and handlers
func _reference_nodes():
	if nodes_referenced:
		return
	var core_map_data = GlobalManager.NodeManager.get_map_data("CoreMap")
	#print("Map data for CoreMap: ", core_map_data)
	
	print("Referencing managers and handlers...")
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "network_meta_manager", managers)
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "network_handler", handlers)
	nodes_referenced = true

# Connect signals for client events
func _connect_signals():
	var enet_client_manager = managers.get("enet_client_manager")
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
