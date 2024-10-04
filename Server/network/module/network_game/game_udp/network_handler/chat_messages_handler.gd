# res://src/core/network/packet_handlers/handle_chat_message.gd (Server)
extends Node

# Signal definition for received chat messages
signal chat_message_received(peer_id: int, message: String)

func initialize():
	pass
	
# Methode zum Verarbeiten von Chat-Nachrichten (PackedByteArray)
func handle_chat_message(peer_id: int, packet: PackedByteArray):
	var message = packet.get_string_from_utf8()
	print("Received chat message from peer_id: ", peer_id, ": ", message)
	
	# Emit a signal so other parts of the server can respond to the chat message
	emit_signal("chat_message_received", peer_id, message)

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling general packet from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des allgemeinen Pakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
