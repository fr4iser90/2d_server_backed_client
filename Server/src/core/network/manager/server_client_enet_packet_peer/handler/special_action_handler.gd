# res://src/core/network/packet_handlers/handle_special_action.gd (Server)
extends Node

# Signal definition for received special action data
signal special_action_received(peer_id: int, action_data: Dictionary)

func initialize():
	pass
	
# Methode zum Verarbeiten von speziellen Aktionen (PackedByteArray)
func handle_special_action(peer_id: int, packet: PackedByteArray):
	var json = JSON.new()
	var parse_result = json.parse(packet.get_string_from_utf8())
	
	if parse_result == OK:
		var action_data = json.get_data()
		print("Received special action data from peer_id: ", peer_id, ": ", action_data)
		
		# Emit a signal with the special action data
		emit_signal("special_action_received", peer_id, action_data)
	else:
		print("Failed to parse special action data from peer_id: ", peer_id)

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling general packet related to special action from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des allgemeinen Pakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet related to special action from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
