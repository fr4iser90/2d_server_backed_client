extends Node

var packet_processor 
var multiplayer_api

var test_packet_processed = {}
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
	
func perform_self_test():
	packet_processor = get_node("/root/ServerMain/NetworkManager/ENetServerManager/PacketProcessor")
	multiplayer_api = get_tree().get_multiplayer() 
	if packet_processor == null:
		print("Error: PacketProcessor is not initialized.")
		return
	
	var handlers = packet_processor.handlers
	if handlers == null:
		print("Error: Handlers are not initialized.")
		return

	print("Handlers initialized successfully.")
	
	self_test_channels()

func self_test_channels():
	print("Starting self-test for channels...")
	
	var test_packet = "Test packet data".to_utf8_buffer()
	var handlers = packet_processor.handlers

	if handlers == null:
		print("Error: Handlers not initialized.")
		return

	for channel in handlers.keys():
		print("Testing channel: ", channel)
		
		# Sende das Paket an den Server selbst (Peer ID 1) auf dem jeweiligen Kanal
		multiplayer_api.send_bytes(test_packet, channel, MultiplayerAPI.RPC_MODE_ANY_PEER)

		# Warte eine kurze Zeit und überprüfe, ob das Paket empfangen wurde
		await get_tree().create_timer(0.5).timeout

		# Überprüfe, ob das Paket empfangen und verarbeitet wurde
		if not check_if_packet_processed(channel):
			print("Channel ", channel, " failed to process the test packet.")
		else:
			print("Channel ", channel, " successfully processed the test packet.")
	
	print("Self-test completed.")

func check_if_packet_processed(channel):
	return test_packet_processed.has(channel) and test_packet_processed[channel]
