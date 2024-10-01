# DatabaseUserLoginHandler GODOT
extends Node

signal login_request_sent

var websocket_multiplayer_manager
var is_initialized = false

func initialize():
	if is_initialized:
		return
	websocket_multiplayer_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_middleware_manager")
	is_initialized = true
	
# This function sends the login data to the server over WebSocket
func process_login(client_data: Dictionary, peer_id: int) -> void:
	var websocket_peer = websocket_multiplayer_manager.get_websocket_peer()
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		var login_packet = {
			"type": "user_auth",  # Specify packet type for login
			"username": client_data.get("username", ""),
			"password": client_data.get("password", "")
		}
		var json_str = JSON.stringify(login_packet)
		websocket_peer.set_target_peer(1)  # Assuming 1 is the server ID
		websocket_peer.put_packet(json_str.to_utf8_buffer())
		print("Sending login data to server: ", json_str)
		emit_signal("login_request_sent")
	else:
		print("WebSocket is not connected, unable to send login data")
