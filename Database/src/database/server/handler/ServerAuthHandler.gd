# res://src/database/server/handler/ServerAuthHandler.gd
extends Node

const VALID_SERVER_KEY = "your_server_key_here"
@onready var web_socket_manager = $"../../../../WebSocketServer/Manager/WebSocketManager"

# Authentifiziert den Server und sendet eine Antwort zurück
func authenticate_server(peer_id: int, server_key: String):
	if server_key == VALID_SERVER_KEY:
		print("Server authenticated successfully for peer: ", peer_id)
		_send_auth_response(peer_id, true)  # Erfolg
	else:
		print("Invalid server key for peer: ", peer_id)
		_send_auth_response(peer_id, false)  # Fehler

# Sende eine Antwort nach der Authentifizierung zurück
func _send_auth_response(peer_id: int, success: bool):
	var auth_status = "success" if success else "failed"
	var response_data = {
		"type": "server_auth_response",
		"auth_status": auth_status
	}
	_send_json_to_peer(peer_id, response_data)

# Utility function to send JSON data to a specific peer
func _send_json_to_peer(peer_id: int, data: Dictionary):
	# Hole die peers_info und websocket_multiplayer_peer von web_socket_manager
	var peers_info = web_socket_manager.peers_info
	var websocket_multiplayer_peer = web_socket_manager.websocket_multiplayer_peer
	
	if peer_id in peers_info:
		var json_str = JSON.stringify(data)
		websocket_multiplayer_peer.set_target_peer(peer_id)
		websocket_multiplayer_peer.put_packet(json_str.to_utf8_buffer())
		print("sending data: ", json_str, " to peer ID : ", peer_id)


