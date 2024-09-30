# res://src/core/network/manager/server_client_enet_packet_peer/handler/core_disconnection_handler.gd (Server)
extends Node

var enet_server_manager
var channel_manager
var packet_manager
var handler_name = "core_connection_handler"
var is_initialized = false

# Initialize the connection handler
func initialize():
	if is_initialized:
		print("CoreConnectionHandler already initialized. Skipping.")
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_packet_manager")
	is_initialized = true

# Handle disconnection events
func handle_disconnection(peer_id: int):
	print("Peer ", peer_id, " disconnected.")
	# Notify about the disconnection
	_notify_peer_of_disconnection(peer_id)


# Notify the peer that they have been disconnected
func _notify_peer_of_disconnection(peer_id: int):
	var disconnection_data = {"status": "disconnected", "message": "You have been disconnected"}
	var err = enet_server_manager.send_packet(peer_id, handler_name, disconnection_data)
	if err != OK:
		print("Failed to send disconnection packet to peer_id: ", peer_id, " Error: ", err)
	else:
		print("Disconnection packet sent successfully to peer_id: ", peer_id)

