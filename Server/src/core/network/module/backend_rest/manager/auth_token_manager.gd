extends Node

var enet_server_manager

# Signal for token validation results
signal token_validated(peer_id: int, success: bool)

var is_initialized = false


func initialize():
	if is_initialized:
		return
	GlobalManager.DebugPrint.debug_info("Initializing auth_token_manager...", self)
	
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	if not enet_server_manager:
		GlobalManager.DebugPrint.debug_error("ENetServerManager not found!", self)
	is_initialized = true

func validate_token(token: String, peer_id: int):
	if not is_initialized:
		initialize()
	var url = GlobalManager.GlobalConfig.BACKEND_URL + "/api/auth/validate-token"
	GlobalManager.DebugPrint.debug_info("Sending token validation request to: " + url, self)
	
	var headers = ["Content-Type: application/json"]
	var body = {"token": token}
	var body_str = JSON.stringify(body)
	
	var token_validation_request = HTTPRequest.new()
	add_child(token_validation_request)
	token_validation_request.connect("request_completed", Callable(self, "_on_token_validation_completed").bind(peer_id))
	
	var err = token_validation_request.request(url, headers, HTTPClient.METHOD_POST, body_str)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Token validation request failed to start, error code: " + str(err), self)
		emit_signal("token_validated", peer_id, false)

func _on_token_validation_completed(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	GlobalManager.DebugPrint.debug_info("Token validation completed for peer: " + str(peer_id) + ", response code: " + str(response_code), self)
	
	if response_code == 200:
		GlobalManager.DebugPrint.debug_info("Token validated successfully for peer: " + str(peer_id), self)
		_send_token_validation_result(peer_id, true)
	else:
		GlobalManager.DebugPrint.debug_warning("Token validation failed for peer: " + str(peer_id) + ", response code: " + str(response_code), self)
		_send_token_validation_result(peer_id, false)

func _send_token_validation_result(peer_id: int, success: bool):
	var channel = 0  # Channel for reliable messages (e.g., authentication)
	
	if success:
		var message = "Token Validated. Welcome to the game!".to_utf8_buffer()
		GlobalManager.DebugPrint.debug_info("Sending success message to peer: " + str(peer_id), self)
		enet_server_manager.send_packet(peer_id, channel, message)
	else:
		var message = "Token Validation Failed".to_utf8_buffer()
		GlobalManager.DebugPrint.debug_warning("Sending failure message to peer: " + str(peer_id), self)
		enet_server_manager.send_packet(peer_id, channel, message)
		enet_server_manager.disconnect_peer(peer_id)

	emit_signal("token_validated", peer_id, success)
