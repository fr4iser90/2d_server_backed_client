# NetworkMiddlewareManager
extends Node

var server_validation_key = GlobalManager.GlobalConfig.get_server_validation_key()
# Signal to trigger the connection to the WebSocket server
signal connect_database_button_pressed

var ip = "127.0.0.1"
var port = "3500"
#var port = GlobalManager.GlobalConfig.get_backend_port()
#var ip = GlobalManager.GlobalConfig.get_backend_ip_dns()
var network_endpoint_manager
var multiplayer_peer: WebSocketMultiplayerPeer
var is_connected = false


# Connect the signal when the node enters the scene tree
func _ready():
	connect("connect_database_button_pressed", Callable(self, "_on_connect_button_pressed"))
	network_endpoint_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_endpoint_manager")

	
# Connect to the WebSocket server when the signal is emitted
func _on_connect_button_pressed():
	connect_to_server()

func connect_to_server():
	multiplayer_peer = WebSocketMultiplayerPeer.new()
	var url = "ws://" + ip + ":" + str(port)
	var err = multiplayer_peer.create_client(url)

	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to connect to WebSocket server. Error: " + str(err), self)
		return

	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.connect("connection_established", Callable(self, "_on_connection_established"))
	multiplayer_peer.connect("connection_closed", Callable(self, "_on_connection_closed"))
	multiplayer_peer.connect("data_received", Callable(self, "_on_data_received"))

func _on_connection_established(protocol: String = ""):
	is_connected = true
	GlobalManager.DebugPrint.debug_info("Connected to WebSocket server at " + ip + ":" + str(port), self)
	# Notify that the connection is established
	emit_signal("connection_established")

func _on_connection_closed(was_clean_close: bool):
	is_connected = false
	GlobalManager.DebugPrint.debug_info("Disconnected from WebSocket server", self)

func _on_data_received():
	var packet = multiplayer_peer.get_packet().get_string_from_utf8()
	GlobalManager.DebugPrint.debug_info("Data received from server: " + packet, self)

	# Delegate the message handling to WebSocketEndpointManager
	if network_endpoint_manager:
		network_endpoint_manager.handle_websocket_message(packet)
	else:
		GlobalManager.DebugPrint.debug_error("Endpoint manager not set.", self)

func send_data_to_server(data: Dictionary):
	if is_connected:
		var json_str = JSON.stringify(data)
		multiplayer_peer.put_packet(json_str.to_utf8_buffer())
	else:
		GlobalManager.DebugPrint.debug_error("Not connected to the server, cannot send data", self)

func _process(delta: float) -> void:
	if multiplayer_peer:
		multiplayer_peer.poll()

