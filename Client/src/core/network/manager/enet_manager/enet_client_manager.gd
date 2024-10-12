# res://src/core/network/manager/enet_client_manager.gd (client)
extends Node


signal enet_client_manager_created_client
signal enet_client_manager_disconnected_from_server
signal enet_client_manager_connection_failed

var enet_client_manager : ENetMultiplayerPeer = null
var connection_timeout_timer: Timer
var channel_manager = null
var packet_manager = null
var user_session_manager = null
var connection_timeout = 10.0

var is_connected = false
var is_connecting = false

func initialize():
	pass

var is_initialized = false

func reference_network_managers():
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	
func create_client_peer():
	reference_network_managers()
	if is_connected or is_connecting:
		print("Already connected or connection in progress. Skipping connect_to_server.")
		return

	is_connecting = true
	var address = user_session_manager.get_server_ip()
	var port = user_session_manager.get_server_port()
	print("Registering ChannelMap")
	channel_manager.register_channel_map()
	packet_manager.cache_channel_map()
	print("Creating a new ENetMultiplayerPeer client. Connecting to: " + address + ":" + str(port))
	enet_client_manager = ENetMultiplayerPeer.new()
	var err = enet_client_manager.create_client(address, port)

	if err == OK:
		print("Client creation successful, via ENetMultiplayerPeer¶ ", get_enet_peer())
		_on_client_created()
	else:
		print("Failed to connect to server: ", err)
		is_connecting = false
		emit_signal("enet_client_manager_connection_failed")

func _on_client_created():
	is_connected = true
	is_connecting = false
	emit_signal("enet_client_manager_created_client")

func _on_disconnected_from_server():
	print("Disconnected from server.")
	is_connected = false
	emit_signal("enet_client_manager_disconnected_from_server")

func get_peer_id() -> int:
	if enet_client_manager:
		return enet_client_manager.get_unique_id()  # Dies gibt die vom Server zugewiesene peer_id zurück
	print("Error: ENet client manager is not initialized.")
	return -1  # Fehlerwert


func get_enet_peer() -> ENetMultiplayerPeer:
	if enet_client_manager:
		return enet_client_manager
	print("Error: ENet client manager is not initialized.")
	return null

func send_packet(handler_name: String, data: Dictionary) -> int:
	if is_instance_valid(enet_client_manager):

		# Create a packet with the channel
		var packet = packet_manager.create_packet_for_handler(handler_name, data)

		# Send the packet over the channel
		var err = enet_client_manager.put_packet(packet)
		if err != OK:
			print("Failed to send packet:", err)
			return err
		return OK
	else:
		print("ENet client instance is not valid, cannot send packet.")
		return ERR_INVALID_PARAMETER
		
func _process(delta):
	if enet_client_manager:
		enet_client_manager.poll()
		while enet_client_manager.get_available_packet_count() > 0:
			var packet = enet_client_manager.get_packet()
			packet_manager.process_packet(packet, 1)

