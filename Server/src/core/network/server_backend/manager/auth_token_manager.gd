# res://src/core/network/server_backend/manager/auth_token_manager.gd
extends Node


var enet_server_manager

# Signal for token validation results
signal token_validated(peer_id: int, success: bool)

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	is_initialized = true
	
func validate_token(token: String, peer_id: int):
	var url =  GlobalManager.GlobalConfig.BACKEND_URL + "/api/auth/validate-token"
	var headers = ["Content-Type: application/json"]
	var body = {"token": token}
	var body_str = JSON.stringify(body)
	
	var token_validation_request = HTTPRequest.new()
	add_child(token_validation_request)
	token_validation_request.connect("request_completed", Callable(self, "_on_token_validation_completed").bind(peer_id))
	
	var err = token_validation_request.request(url, headers, HTTPClient.METHOD_POST, body_str)
	if err != OK:
		print("Token validation request failed to start, error code: ", err)
		emit_signal("token_validated", peer_id, false)

func _on_token_validation_completed(result: int, response_code: int, headers: Array, body: PackedByteArray, peer_id: int):
	if response_code == 200:
		_send_token_validation_result(peer_id, true)
	else:
		_send_token_validation_result(peer_id, false)

func _send_token_validation_result(peer_id: int, success: bool):
	var channel = 0  # Kanal für zuverlässige Nachrichten (z.B. Authentifizierung)

	if success:
		print("Token validated successfully for peer: ", peer_id)
		var packet = "Token Validated. Welcome to the game!".to_utf8_buffer()
		enet_server_manager.send_packet(peer_id, channel, packet)  # Kanal hinzufügen
	else:
		print("Token validation failed for peer: ", peer_id)
		var packet = "Token Validation Failed".to_utf8_buffer()
		enet_server_manager.send_packet(peer_id, channel, packet)  # Kanal hinzufügen
		enet_server_manager.disconnect_peer(peer_id)

	emit_signal("token_validated", peer_id, success)
