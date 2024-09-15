# res://src/core/network/packet_handlers/handle_data.gd (Server)
extends Node

func initialize():
	pass
	
# Methode zum Verarbeiten von Datenpaketen (PackedByteArray)
func handle_data(peer_id: int, packet: PackedByteArray):
	print("Handling data from peer_id: ", peer_id)
	
	var json = JSON.new()
	var parse_result = json.parse(packet.get_string_from_utf8())
	
	if parse_result == OK:
		var data = json.get_data()
		print("Data received: ", data)
		# Here you would process the game data, such as updating player position
		if data.has("position"):
			var position = data["position"]
			# Process the position data, e.g., update player position in the game
	else:
		print("Failed to parse data from peer_id: ", peer_id)

# Methode zum Verarbeiten von allgemeinen Paketen (PackedByteArray)
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling general packet from peer: ", packet_peer_id)
	# Hier die Logik zur Verarbeitung des allgemeinen Pakets implementieren

# Methode zum Verarbeiten von Dictionary-Paketen
func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling dictionary packet from peer: ", packet_peer_id)
	print("Packet data:", packet)
	# Hier die Logik zur Verarbeitung des Dictionary-Pakets implementieren
