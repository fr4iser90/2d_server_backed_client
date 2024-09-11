# res://src/core/network/packet_handlers/handle_disconnection.gd (Server)
extends Node

func initialize():
	pass
	
# Methode zum Verarbeiten von Trennungsereignissen
func handle_disconnection(peer_id: int, connection_manager: Node):
	print("Player disconnected: ", peer_id)
	
	# Perform any cleanup required for a disconnecting player
	if connection_manager:
		connection_manager.handle_disconnect(peer_id)
	else:
		print("Connection manager not found for handling disconnection.")

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling packet related to disconnection from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des Pakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet related to disconnection from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
