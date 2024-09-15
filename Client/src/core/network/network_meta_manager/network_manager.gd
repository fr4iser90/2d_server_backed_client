# res://src/core/network/manager/network_manager.gd (Client)
extends Node

# Managers and Handlers
var handlers = {}
var managers = {}

signal network_manager_connected_to_server
signal network_manager_disconnected_from_server
signal network_manager_connection_failed
signal enet_peer_ready

var is_connected = false
var is_initialized = false
var node_init_status = {}

func _ready():
	print("Initializing Client NetworkManager... Using UDP ENetMultiplayerPeer library")
	_reference_nodes()
	_initialize_nodes()
	_connect_signals()

# Dynamically reference all managers and handlers
func _reference_nodes():
	print("Referencing managers and handlers...")
	_reference_entities("network_meta_manager", GlobalManager.NodeConfig.network_meta_manager, managers)
	_reference_entities("basic_handler", GlobalManager.NodeConfig.basic_handler, handlers)
	_reference_entities("backend_handler", GlobalManager.NodeConfig.backend_handler, handlers)

func _reference_entities(node_type: String, paths: Dictionary, target: Dictionary):
	for key in paths.keys():
		var node = GlobalManager.GlobalNodeManager.get_node_from_config(node_type, key)  # Pass node_type and key
		if node:
			target[key] = node
			print("Referenced: " + key)
		else:
			print("Error: Could not reference " + key + ".")

			

# Initialize all nodes (managers and handlers)
func _initialize_nodes():
	if is_initialized:
		print("NetworkManager is already initialized. Skipping re-initialization.")
		return

	print("Initializing all managers and handlers...")

	is_initialized = true

# Connect relevant signals
func _connect_signals():
	if not managers.has("enet_client_manager"):
		print("Error: enet_client_manager is null, cannot connect signals.")
		return
	
	print("Connecting signals...")
	var client_manager = managers.enet_client_manager
	
	if client_manager.has_signal("enet_client_manager_connected_to_server"):
		client_manager.connect("enet_client_manager_connected_to_server", Callable(self, "_on_connected_reached"))
	else:
		print("Warning: 'connected_to_server' signal not found in enet_client_manager.")
	
	if client_manager.has_signal("enet_client_manager_disconnected_from_server"):
		client_manager.connect("disconnected_from_server", Callable(self, "_on_disconnected"))
	else:
		print("Warning: 'disconnected_from_server' signal not found in enet_client_manager.")
	
	if client_manager.has_signal("enet_client_manager_connection_failed"):
		client_manager.connect("connection_failed", Callable(self, "_on_connection_failed"))
	else:
		print("Warning: 'connection_failed' signal not found in enet_client_manager.")

func connect_to_server():
	if managers.has("enet_client_manager"):
		managers["enet_client_manager"].connect_to_server()
	else:
		print("Error: enet_client_manager is null, cannot connect to server!")

# Signal callback methods
func _on_connected_reached():
	is_connected = true
	var channel_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_meta_manager", "channel_manager")
	var packet_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_meta_manager", "packet_manager")
	channel_manager.register_global_channel_map()
	packet_manager.cache_channel_map()
	emit_signal("network_manager_connected_to_server")

func _on_disconnected():
	is_connected = false
	emit_signal("network_manager_disconnected_from_server")

func _on_connection_failed():
	is_connected = false
	emit_signal("network_manager_connection_failed")
