extends Node

var is_initialized = false  # Doppelinitialisierung verhindern
var player_sessions = {}  # Dictionary, das Peer-IDs den Spielern zuordnet

func initialize():
	if is_initialized:
		print("Server is already initialized. Skipping initialization.")
		return
	reference_dependencies()
	is_initialized = true

func reference_dependencies():
	# Hier könnten wir den ENet Server Manager referenzieren, um auf die Peer-Signale zu hören
	var enet_server_manager = get_node("/root/NetworkManager/EnetServerManager")
	enet_server_manager.connect("peer_connected", Callable(self, "_on_peer_connected"))
	enet_server_manager.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))

func _on_peer_connected(peer_id: int):
	# Hier wird ein neuer Spieler registriert
	print("Player connected with Peer ID: ", peer_id)
	player_sessions[peer_id] = {"peer_id": peer_id, "data": {}}  # Spielerinfos kannst du später erweitern
	print("Current player sessions: ", player_sessions)

func _on_peer_disconnected(peer_id: int):
	# Spieler wird entfernt, wenn er sich trennt
	if player_sessions.has(peer_id):
		player_sessions.erase(peer_id)
		print("Player with Peer ID ", peer_id, " disconnected.")
	print("Updated player sessions: ", player_sessions)

# Diese Funktion kannst du erweitern, um spezifische Daten zu jedem Spieler zu speichern
func update_player_data(peer_id: int, data: Dictionary):
	if player_sessions.has(peer_id):
		player_sessions[peer_id]["data"] = data
		print("Updated data for player: ", peer_id)
	else:
		print("No session found for peer_id: ", peer_id)
