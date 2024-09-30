# DatabaseGodotServerAuthHandler
extends Node

signal authentication_complete(success: bool)

var retry_count := 0
var max_retries := 3
var retry_delay := 1.0  # Seconds

var websocket_peer: WebSocketMultiplayerPeer = null
var is_initialized = false  

func initialize(peer: WebSocketMultiplayerPeer):
	if is_initialized:
		return
	is_initialized = true
	websocket_peer = peer
	GlobalManager.DebugPrint.debug_info("WebSocketServerAuthHandler initialized.", self)

# Trigger server authentication via WebSocket
func authenticate_server():
	if not is_initialized:
		GlobalManager.DebugPrint.debug_error("WebSocketServerAuthHandler not initialized!", self)
		return
	
	var request_data = {
		"action": "server_auth",
		"server_key": GlobalManager.GlobalConfig.get_server_validation_key()
	}

	_send_message_to_server(request_data)

# Send WebSocket message
func _send_message_to_server(message: Dictionary):
	if websocket_peer and websocket_peer.is_connected_to_host():
		var json_message = JSON.stringify(message)
		websocket_peer.put_packet(json_message.to_utf8_buffer())
	else:
		GlobalManager.DebugPrint.debug_error("WebSocket peer is not connected. Cannot send message.", self)

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
