extends Node

var enet_peer: ENetMultiplayerPeer = null
var utils = null
var heartbeat_timer: Timer

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
	
func initialized(peer_manager, utils_reference):
	enet_peer = peer_manager.enet_peer
	utils = utils_reference
	heartbeat_timer = Timer.new()
	heartbeat_timer.set_wait_time(5.0)
	heartbeat_timer.set_one_shot(true)
	peer_manager.add_child(heartbeat_timer)

func start_heartbeat():
	heartbeat_timer.connect("timeout", Callable(self, "send_heartbeat"))
	heartbeat_timer.start()

func stop_heartbeat():
	if heartbeat_timer.is_connected("timeout", Callable(self, "send_heartbeat")):
		heartbeat_timer.disconnect("timeout", Callable(self, "send_heartbeat"))
	heartbeat_timer.stop()

func send_heartbeat():
	if utils.is_peer_connected(enet_peer):
		var packet = "heartbeat".to_utf8_buffer()
		enet_peer.set_target_peer(0)  # Sending heartbeat on channel 0
		enet_peer.put_packet(packet)
		print("Heartbeat sent to server on channel 0.")
	else:
		emit_signal("disconnected_from_server")
		stop_heartbeat()
	heartbeat_timer.start()  # Restart the timer for the next heartbeat
