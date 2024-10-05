# PacketSendHandler.gd
extends Node

@onready var enet_server_manager = $"../.."


var packet_manager
var channel_manager
var is_initialized = false


func initialize():
	if is_initialized:
		return
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_packet_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_channel_manager")
	is_initialized = true

	
func send_packet(peer_id: int, handler_name: String, data: Dictionary) -> int:
	if is_instance_valid(enet_server_manager):
		packet_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_packet_manager")
		var packet = packet_manager.create_packet_for_handler(handler_name, data)

		if packet.size() == 0:
			GlobalManager.DebugPrint.debug_error("Failed to create packet for handler: " + handler_name, self)
			return ERR_INVALID_PARAMETER

		enet_server_manager.set_target_peer(peer_id)
		var err = enet_server_manager.put_packet(packet)
		if err != OK:
			GlobalManager.DebugPrint.debug_error("Failed to send packet: " + str(err), self)
			return err
		return OK
	else:
		GlobalManager.DebugPrint.debug_error("ENet server instance is not valid, cannot send packet.", self)
		return ERR_INVALID_PARAMETER
