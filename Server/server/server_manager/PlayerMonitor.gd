extends Node

# Dictionary, um den Zustand der Spieler zu speichern
var player_states = {}

# Signal, um Änderungen am Spielerstatus zu verfolgen
signal player_state_changed(peer_id: int, player_data: Dictionary)

# Funktion zum Hinzufügen eines Spielers zum Monitor
func add_player(peer_id: int, instance_key: String, position: Vector2):
	player_states[peer_id] = {
		"instance_key": instance_key,
		"position": position
	}
	emit_signal("player_state_changed", peer_id, player_states[peer_id])
	print("Player added to monitor: Peer ID:", peer_id, "Instance:", instance_key, "Position:", position)

# Funktion zum Aktualisieren der Position eines Spielers
func update_player_position(peer_id: int, position: Vector2):
	if player_states.has(peer_id):
		player_states[peer_id]["position"] = position
		emit_signal("player_state_changed", peer_id, player_states[peer_id])
		print("Player position updated: Peer ID:", peer_id, "Position:", position)
	else:
		print("Error: Player not found in monitor")

# Funktion zum Entfernen eines Spielers vom Monitor
func remove_player(peer_id: int):
	if player_states.has(peer_id):
		player_states.erase(peer_id)
		emit_signal("player_state_changed", peer_id, {})
		print("Player removed from monitor: Peer ID:", peer_id)
	else:
		print("Error: Player not found in monitor")

# Funktion, um den Zustand aller Spieler anzuzeigen
func display_all_players():
	print("Current players being monitored:")
	for peer_id in player_states.keys():
		var state = player_states[peer_id]
		print("Peer ID:", peer_id, "Instance:", state["instance_key"], "Position:", state["position"])

# Funktion, um den Zustand eines bestimmten Spielers anzuzeigen
func display_player(peer_id: int):
	if player_states.has(peer_id):
		var state = player_states[peer_id]
		print("Peer ID:", peer_id, "Instance:", state["instance_key"], "Position:", state["position"])
	else:
		print("Error: Player not found in monitor")
