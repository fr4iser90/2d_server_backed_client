# src/Core/AuthenticationManagement/AuthTokenManager.gd
extends Node

var backend_url = "http://localhost:3000"
@onready var network_manager = preload("res://src/Core/NetworkManagement/NetworkManager.gd").new()

# Signal for token validation results
signal token_validated(peer_id: int, success: bool)

func validate_token(token: String, peer_id: int):
	var url = backend_url + "/api/auth/validate-token"
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
	if success:
		print("Token validated successfully for peer: ", peer_id)
		var packet = "Token Validated. Welcome to the game!".to_utf8_buffer()
		network_manager.send_packet(peer_id, packet)
	else:
		print("Token validation failed for peer: ", peer_id)
		var packet = "Token Validation Failed".to_utf8_buffer()
		network_manager.send_packet(peer_id, packet)
		network_manager.disconnect_peer(peer_id)

	emit_signal("token_validated", peer_id, success)
