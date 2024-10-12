# ENetServerStartHandler
extends Node

var enet_server_manager
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetServerManager")



# Start server logic is outsourced, but peer management remains in the manager
func start_server(port: int, enet_multiplayer_peer: ENetMultiplayerPeer) -> void:
	if not is_initialized:
		initialize()
	var err = enet_multiplayer_peer.create_server(port, 32)
	if err == OK:
		var server_peer_id = enet_multiplayer_peer.get_unique_id()
		print(err)
		GlobalManager.DebugPrint.debug_info("Server started on port " + str(port) + " | Server Peer ID: " + str(server_peer_id), self)
		enet_multiplayer_peer.connect("peer_connected", Callable(get_parent(), "_on_peer_connected"))
		enet_multiplayer_peer.connect("peer_disconnected", Callable(get_parent(), "_on_peer_disconnected"))
		# Reference the manager explicitly (assuming it's the direct parent):
		enet_server_manager.set_process(true)
		enet_server_manager.emit_signal("enet_server_started")

	else:
		GlobalManager.DebugPrint.debug_error("Failed to start server: " + str(err), self)
		get_parent().set_process(false)

