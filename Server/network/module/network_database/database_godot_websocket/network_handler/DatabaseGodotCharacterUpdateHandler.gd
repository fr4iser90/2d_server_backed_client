# DatabaseCharacterUpdateHandler
extends Node

signal character_data_update_success(peer_id: int, character_data: Dictionary)
signal character_data_update_failed(reason: String)

var user_session_manager
var character_manager
var instance_manager
var character_class
var websocket_multiplayer_manager
var is_initialized = false

func initialize():
	if is_initialized:
		return
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	character_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "CharacterManager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceManager")
	websocket_multiplayer_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkMiddlewareManager")
	is_initialized = true


# Process character update by sending it to the WebSocket server
func process_character_update(peer_id: int, character_id: String, character_data: Dictionary):
	initialize()  # Ensure the handler is initialized

	# Fetch the user ID associated with the peer
	var user_id = user_session_manager.get_user_id(peer_id)

	# Prepare WebSocket connection
	var websocket_peer = websocket_multiplayer_manager.get_websocket_peer()

	# Check if WebSocket is connected
	if websocket_peer and websocket_peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_CONNECTED:
		var update_packet = {
			"type": "character",  
			"action": "update_character",  
			"character_id": character_id,
			"character_data": character_data,  # Include updated character data
			"user_id": user_id,
		}
		var json_str = JSON.stringify(update_packet)

		# Assuming 1 is the server's peer ID
		websocket_peer.set_target_peer(1)
		websocket_peer.put_packet(json_str.to_utf8_buffer())

		emit_signal("character_data_update_success", peer_id, character_data)
	else:
		emit_signal("character_data_update_failed", "WebSocket is not connected")
		print("WebSocket is not connected, unable to send update character data")


# Handle the response from the server for character update (optional)
func handle_update_character_response(packet: Dictionary):
	var success = packet.get("success", false)
	if success:
		print("Character data updated successfully")
	else:
		var reason = packet.get("reason", "Unknown error")
		print("Failed to update character data: ", reason)
