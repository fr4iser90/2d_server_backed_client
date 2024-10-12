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
	
func handle_event_triggered(peer_id: int, packet: PackedByteArray):
	var json = JSON.new()
	var parse_result = json.parse(packet.get_string_from_utf8())
	if parse_result == OK:
		var event_data = json.get_data()
		print("Received event data: ", event_data)
		emit_signal("event_triggered_received", event_data)
	else:
		print("Failed to parse event data.")
