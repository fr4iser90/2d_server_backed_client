# res://src/core/network/packet_handlers/handle_player_status_update.gd (Client)
extends Node

var enet_client_manager = null
var channel_manager = null
var packet_manager = null

var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true
	
func handle_player_status_update(peer_id: int, packet: PackedByteArray):
	var json = JSON.new()
	var parse_result = json.parse(packet.get_string_from_utf8())
	if parse_result == OK:
		var status_data = json.get_data()
		print("Received player status update: ", status_data)
		emit_signal("player_status_update_received", status_data)
	else:
		print("Failed to parse player status update data.")
