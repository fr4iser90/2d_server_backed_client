# res://src/core/network/packet_handlers/handle_player_status_update.gd (Server)
extends Node

# Signal definition for received player status updates
signal player_status_update_received(peer_id: int, status_data: Dictionary)

func initialize():
	pass
	
# Methode zum Verarbeiten von Spielerstatus-Updates (PackedByteArray)
func handle_player_status_update(peer_id: int, packet: PackedByteArray):
	var json = JSON.new()
	var parse_result = json.parse(packet.get_string_from_utf8())
	
	if parse_result == OK:
		var status_data = json.get_data()
		print("Received player status update from peer_id: ", peer_id, ": ", status_data)
		
		# Emit a signal with the updated status data
		emit_signal("player_status_update_received", peer_id, status_data)
	else:
		print("Failed to parse player status update from peer_id: ", peer_id)

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling general packet related to player status update from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des allgemeinen Pakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet related to player status update from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
