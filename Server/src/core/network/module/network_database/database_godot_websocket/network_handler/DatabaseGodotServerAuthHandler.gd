extends Node

signal authentication_complete(success: bool)

var retry_count := 0
var max_retries := 3
var retry_delay := 1.0  # Seconds
var is_initialized = false  
var connection_check_timer: Timer = null 
var network_middleware_manager = null  # Reference to the middleware manager

func _ready():
	GlobalManager.DebugPrint.debug_info("WebSocketServerAuthHandler initialized.", self)
	
	# Fetch the NetworkMiddlewareManager directly
	network_middleware_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_middleware_manager")
	
	# Start a timer to check the connection status periodically
	connection_check_timer = Timer.new()
	connection_check_timer.wait_time = 0.5  # Check every 0.5 seconds
	connection_check_timer.autostart = true
	connection_check_timer.one_shot = false
	connection_check_timer.connect("timeout", Callable(self, "_check_connection_status"))
	add_child(connection_check_timer)

# Check the WebSocket connection status
func _check_connection_status():
	var websocket_peer = network_middleware_manager.get_websocket_peer()
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		# Stop the timer once connected
		connection_check_timer.stop()
		authenticate_server()

# Trigger server authentication via WebSocket
func authenticate_server():
	var websocket_peer = network_middleware_manager.get_websocket_peer()
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		var request_data = {
			"action": "server_auth",
			"server_key": GlobalManager.GlobalConfig.get_server_validation_key()
		}
		_send_message_to_server(request_data)
	else:
		GlobalManager.DebugPrint.debug_error("WebSocket peer is not connected!", self)

# Send WebSocket message
func _send_message_to_server(message: Dictionary):
		# Print the Peer ID upon connection attempt
	var websocket_peer = network_middleware_manager.get_websocket_peer()
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		var json_message = JSON.stringify(message)
		#print("sending data:", websocket_peer, " message: ", json_message)
		network_middleware_manager.send_data_to_server(message)
	else:
		GlobalManager.DebugPrint.debug_error("Cannot send message, WebSocket peer is null or not connected.", self)

# Handle incoming message (assuming response for server authentication)
func handle_incoming_message(message_data: Dictionary):
	if message_data.has("auth_status"):
		if message_data["auth_status"] == "success":
			GlobalManager.DebugPrint.debug_info("Server authentication successful.", self)
			emit_signal("authentication_complete", true)
		else:
			GlobalManager.DebugPrint.debug_warning("Server authentication failed.", self)
			_start_retry_authentication()

# Retry authentication in case of failure
func _start_retry_authentication():
	if retry_count < max_retries:
		retry_count += 1
		GlobalManager.DebugPrint.debug_warning("Retrying authentication in " + str(retry_delay) + " seconds... (Attempt " + str(retry_count) + " of " + str(max_retries) + ")", self)
		var retry_timer = Timer.new()
		retry_timer.wait_time = retry_delay
		retry_timer.one_shot = true
		add_child(retry_timer)
		retry_timer.connect("timeout", Callable(self, "_on_retry_timeout"))
		retry_timer.start()
	else:
		GlobalManager.DebugPrint.debug_error("Authentication failed after " + str(max_retries) + " attempts.", self)
		emit_signal("authentication_complete", false)

func _on_retry_timeout():
	GlobalManager.DebugPrint.debug_info("Retrying server authentication...", self)
	authenticate_server()
