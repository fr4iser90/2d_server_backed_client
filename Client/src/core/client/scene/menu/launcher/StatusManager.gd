# res://src/core/client/scene/menu/launcher/StatusManager.gd (Client)
extends Control

@onready var status_label = $StatusLabel

var network_module
var core_connection_handler

func _ready():
	#network_module = get_node("/root/Core/Network")
	network_module = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	core_connection_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService",  "CoreConnectionService")
	if network_module:
		_connect_signals()
		
func _connect_signals():
	if network_module:
		network_module.connect("network_module_connected_to_server", Callable(self, "_on_connected"))
		network_module.connect("network_module_disconnected_from_server", Callable(self, "_on_disconnected"))
		network_module.connect("network_module_connection_failed", Callable(self, "_on_connection_failed"))
		
	# Connect signals for the core connection handler
	if core_connection_handler:
		core_connection_handler.connect("connection_established", Callable(self, "_on_connection_established"))
		core_connection_handler.connect("connection_failed", Callable(self, "_on_connection_failed_with_reason"))

# Signal handling methods
func _on_connected():
	status_label.text = "Connecting to Server, waiting for response"
	print("Waiting for server response")

func _on_connection_established():
	status_label.text = "Connected to server successfully."
	print("Connected to server")

func _on_disconnected():
	status_label.text = "Disconnected from server."
	print("Disconnected from server")

func _on_connection_failed():
	status_label.text = "Failed to connect to server."
	print("Connection failed")

func _on_connection_failed_with_reason(reason: String):
	status_label.text = "Connection failed: " + reason
	print("Connection failed with reason: ", reason)
