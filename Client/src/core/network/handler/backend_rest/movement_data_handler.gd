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
	network_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true
	
func handle_movement_data(peer_id: int, packet: PackedByteArray):
	if packet.size() > 0:
		var message = packet.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(message)

		if parse_result == OK:
			var movement_data = json.get_data()
			print(peer_id)
			emit_signal("network_peer_packet_received", peer_id, packet)
		else:
			print("Failed to parse JSON ENET data: ", message)
	else:
		print("Received empty or non-UTF-8 packet from peer: ", peer_id)
