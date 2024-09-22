# res://src/core/network/manager/server_client_enet_packet_peer/handler/core_connection_handler.gd (Server)
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
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true

# Handle connection requests
func handle_connection_request(peer_id: int):
	print("Handling connection request from peer_id: ", peer_id)
	# Notify that the connection has been established
	_notify_peer_of_connection(peer_id)

# Notify the peer that the connection has been established
func _notify_peer_of_connection(peer_id: int):
	var connection_data = {"status": "connected", "message": "Connection established successfully"}
	var err = enet_server_manager.send_packet(peer_id, handler_name, connection_data)
	if err != OK:
		print("Failed to send connection packet to peer_id: ", peer_id, " Error: ", err)
	else:
		print("Connection packet sent successfully to peer_id: ", peer_id)


