# res://src/core/network/packet_handlers/self_test_channels.gd (Server)
extends Node

var packet_processor 
var multiplayer_api

var test_packet_processed = {}

func initialize():
	pass
	
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
	var test_packet_dict = {
		"key": "Test dictionary data"
	}

	var handlers = packet_processor.handlers

	if handlers == null:
		print("Error: Handlers not initialized.")
		return

	for channel in handlers.keys():
		print("Testing channel: ", channel)
		
		# Sende das PackedByteArray-Paket an den Server selbst (Peer ID 1) auf dem jeweiligen Kanal
		multiplayer_api.send_bytes(test_packet, channel, MultiplayerAPI.RPC_MODE_ANY_PEER)

		# Sende das Dictionary-Paket an den Server selbst
		multiplayer_api.send_json(test_packet_dict, channel, MultiplayerAPI.RPC_MODE_ANY_PEER)

		# Warte eine kurze Zeit und überprüfe, ob das Paket empfangen wurde
		await get_tree().create_timer(0.5).timeout

		# Überprüfe, ob das PackedByteArray-Paket empfangen und verarbeitet wurde
		if not check_if_packet_processed(channel):
			print("Channel ", channel, " failed to process the test packet.")
		else:
			print("Channel ", channel, " successfully processed the test packet.")
	
	print("Self-test completed.")

func check_if_packet_processed(channel):
	return test_packet_processed.has(channel) and test_packet_processed[channel]

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling packet during self-test from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des allgemeinen Pakets implementieren
	test_packet_processed[packet_peer_id] = true

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet during self-test from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
	test_packet_processed[packet_peer_id] = true
