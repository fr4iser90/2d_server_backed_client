# ENetServerOnPeerConnectedHandler
extends Node

signal peer_connected(peer_id: int)




func handle_peer_connected(peer_id: int, connected_peers: Dictionary):
	connected_peers[peer_id] = true
	emit_signal("peer_connected", peer_id)
	GlobalManager.DebugPrint.debug_info("Peer connected: " + str(peer_id), self)
	
	var core_connection_handler = GlobalManager.NodeManager.get_cached_node("network_game_handler", "core_connection_handler")
	if core_connection_handler:
		core_connection_handler.handle_connection_request(peer_id)
