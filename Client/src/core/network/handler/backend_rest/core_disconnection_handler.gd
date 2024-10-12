# res://src/core/network/packet_handlers/handle_disconnection.gd

extends Node

var network_manager = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null

var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	network_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	is_initialized = true
	
func handle_disconnection(peer_id: int, connection_manager: Node):
	print("Player disconnected: ", peer_id)
	
	# Perform any cleanup required for a disconnecting player
	if connection_manager:
		connection_manager.handle_disconnect(peer_id)
	else:
		print("Connection manager not found for handling disconnection.")
