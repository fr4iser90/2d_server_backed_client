extends Node

var network_module = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null

var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	network_module = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_module")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true

func handle_chat_message(peer_id: int, packet: PackedByteArray):
	var message = packet.get_string_from_utf8()
	print("Received chat message: ", message)
	emit_signal("chat_message_received", message)
