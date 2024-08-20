extends Node

var enet_peer: ENetMultiplayerPeer
var player_positions = {}
var player_names = {}
var player_data = {}

func _ready():
	if multiplayer and multiplayer.multiplayer_peer:
		print("Multiplayer peer initialized")
	else:
		print("Multiplayer peer not initialized")

func init(enet_peer_instance: ENetMultiplayerPeer):
	enet_peer = enet_peer_instance

func process_received_data(peer_id: int, packet: PackedByteArray):
	# Konvertiere das Byte-Array in einen UTF-8-String
	var message = packet.get_string_from_utf8()

	# Debugging-Ausgabe
	print("Received packet from peer_id ", peer_id, ": ", message)

	# Erstelle ein JSON-Objekt zum Parsen der Nachricht
	var json = JSON.new()
	var parse_result = json.parse(message)

	# Überprüfe das Parsing-Ergebnis
	if parse_result == OK:
		# Daten erfolgreich geparsed
		var movement_data = json.get_data()

		# Debugging-Ausgabe für die geparsten Daten
		print("Parsed movement data for peer_id ", peer_id, ": ", movement_data)

		# Überprüfe, ob die Daten die erwartete Struktur haben
		if typeof(movement_data) == TYPE_DICTIONARY and movement_data.has("position") and movement_data.has("velocity"):
			var position_str = movement_data["position"]
			var velocity_str = movement_data["velocity"]

			# Konvertiere die Position und Velocity Strings in Vector2
			var position = parse_vector2(position_str)
			var velocity = parse_vector2(velocity_str)

			if position != Vector2() and velocity != Vector2():
				process_movement_data(peer_id, {
					"position": position,
					"velocity": velocity
				})
			else:
				print("Failed to convert position or velocity to Vector2 for peer_id ", peer_id)
		else:
			print("Invalid movement data format from peer_id ", peer_id, ": ", movement_data)
	else:
		# Fehlgeschlagenes Parsing
		print("Failed to parse JSON data from client: ", peer_id, ", Error: ", parse_result)

func process_movement_data(peer_id: int, movement_data: Dictionary):
	var new_position = movement_data.get("position", Vector2())
	var velocity = movement_data.get("velocity", Vector2())

	# Überprüfen, ob die Rückgabewerte gültig sind
	if new_position != Vector2() and velocity != Vector2():
		if is_valid_movement(peer_id, new_position, velocity):
			player_positions[peer_id] = new_position
			emit_signal("player_position_updated", peer_id, new_position)
			sync_movement_with_clients(peer_id, new_position, velocity)
		else:
			print("Invalid movement detected for peer: ", peer_id)
	else:
		print("Failed to parse movement data for peer: ", peer_id)

func parse_vector2(vector_str: String) -> Vector2:
	# Entferne die Klammern und teile die Koordinaten auf
	vector_str = vector_str.replace("(", "").replace(")", "")
	var coordinates = vector_str.split(", ")

	if coordinates.size() == 2:
		var x = coordinates[0].to_float()
		var y = coordinates[1].to_float()
		return Vector2(x, y)
	else:
		# Gib einen Standardwert zurück, falls die Eingabe ungültig ist
		print("Invalid vector string format: ", vector_str)
		return Vector2()  # Standardwert (0, 0)

func is_valid_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool:
	return true

func sync_movement_with_clients(peer_id: int, position: Vector2, velocity: Vector2):
	var player_name = player_names.get(peer_id, "Unknown")
	var movement_data = {
		"peer_id": peer_id,
		"player_name": player_name,
		"position": position,
		"velocity": velocity
	}

	var json = JSON.new()
	var json_string = json.stringify(movement_data)

	if json_string == "":
		print("Failed to serialize JSON data for peer: ", peer_id)
		return

	var packet = json_string.to_utf8_buffer()

	if multiplayer.multiplayer_peer:
		var channel = 1
		var reliable = true

		var result = multiplayer.send_bytes(packet, channel, peer_id, reliable)

		if result:
			print("Movement data sent successfully for peer: ", peer_id)
		else:
			print("Failed to send movement data for peer: ", peer_id)
			var peer = multiplayer.multiplayer_peer.get_peer(peer_id)
			if peer:
				if peer.is_connected():
					print("Peer is connected: ", peer_id)
				else:
					print("Peer is not connected: ", peer_id)
			else:
				print("Peer not found in multiplayer peer list: ", peer_id)
	else:
		print("Multiplayer peer is not initialized.")

func get_all_players_data() -> Dictionary:
	var data = {}
	# Füge Daten hinzu
	for peer_id in player_data.keys():
		data[peer_id] = player_data[peer_id]
	print("Player data to send: ", data)  # Debugging-Ausgabe
	return data

func remove_player(peer_id: int):
	player_positions.erase(peer_id)
	print("Player removed from movement tracking: ", peer_id)
