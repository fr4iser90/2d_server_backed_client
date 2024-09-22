# res://src/game/player_manager/PlayerMovementManager.gd (Client)
extends Node

signal position_received(peer_id: int, position: Vector2)

var enet_client_manager = null
var network_manager
var channel_manager
var packet_manager
var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_characters already initialized. Skipping.")
		return

	network_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true
	

func send_movement_to_server(position: Vector2, velocity: Vector2, peer_id: int):
	if enet_client_manager:
		var handler_name = "player_movement_handler"
		var movement_data = {
			"position": position,
			"velocity": velocity,
			"peer_id": peer_id,
		}
		print("teeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee")
		var err = enet_client_manager.send_packet(handler_name, movement_data)
		if err != OK:
			print("Failed to send packet:", err)
	else:
		print("ENet client instance is not valid, cannot send packet.")

func _on_network_peer_packet_received(id: int, packet: PacketPeer):
	print("Packet received from peer: ", id)
	var message_str = packet.get_string_from_utf8()
	var movement_data = JSON.parse_string(message_str)
	
	if movement_data.error == OK:
		if movement_data.result["peer_id"] != get_tree().get_multiplayer().get_unique_id():
			emit_signal("position_received", movement_data.result["peer_id"], movement_data.result["position"])
		else:
			print("Ignoring packet from self.")
	else:
		print("Failed to parse JSON: ", movement_data.error)
