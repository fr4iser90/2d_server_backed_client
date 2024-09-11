# res://src/core/network/packet_handlers/handle_heartbeat.gd (Server)
extends Node

func initialize():
	pass
	
# Methode zum Verarbeiten von Heartbeat-Paketen (PackedByteArray)
func handle_heartbeat(peer_id: int, packet: PackedByteArray):
	var message = packet.get_string_from_utf8()
	if message == "heartbeat":
		print("Heartbeat received from peer_id: ", peer_id)
	else:
		print("Unexpected message on heartbeat channel from peer_id: ", peer_id)

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling connection packet from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des Verbindungspakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
