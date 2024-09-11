# res://src/core/network/packet_handlers/handle_event_triggered.gd (Server)
extends Node

# Signal definition for received event data
signal event_triggered_received(peer_id: int, event_data: Dictionary)

func initialize():
	pass
	
# Methode zum Verarbeiten von ausgelösten Ereignissen (PackedByteArray)
func handle_event_triggered(peer_id: int, packet: PackedByteArray):
	var json = JSON.new()
	var parse_result = json.parse(packet.get_string_from_utf8())
	
	if parse_result == OK:
		var event_data = json.get_data()
		print("Received event data from peer_id: ", peer_id, ": ", event_data)
		
		# Emit a signal with the event data
		emit_signal("event_triggered_received", peer_id, event_data)
	else:
		print("Failed to parse event data from peer_id: ", peer_id)

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling general packet from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des allgemeinen Pakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet related to event from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
