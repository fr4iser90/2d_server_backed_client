# res://src/core/server/modules/log_module.gd (Server)
extends Node

signal log_message(message: String)
signal player_data_changed  # Signal, wenn Spielerdaten sich ändern

var player_data = {}
var enet_server_manager
var is_initialized = false  # To prevent double initialization

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_manager", "enet_server_manager")
	if enet_server_manager == null:
		return
	enet_server_manager.connect("peer_connected", Callable(self, "log_player_connected"))
	enet_server_manager.connect("peer_disconnected", Callable(self, "log_player_disconnected"))
	is_initialized = true
	emit_signal("log_module_server_ready")
	
# Spieler verbindet sich
func log_player_connected(peer_id: int):
	player_data[peer_id] = { "status": "connected" }
	custom_log("Player connected: " + to_json({
		"peer_id": peer_id,
		"status": "connected"
	}))
	emit_signal("player_data_changed")  # Signal senden, dass sich Spielerdaten geändert haben

# Spieler trennt sich
func log_player_disconnected(peer_id: int):
	if peer_id in player_data:
		player_data[peer_id]["status"] = "disconnected"
		custom_log("Player disconnected: " + to_json({
			"peer_id": peer_id,
			"status": "disconnected"
		}))
		emit_signal("player_data_changed")  # Signal senden, dass sich Spielerdaten geändert haben
	else:
		custom_log("Unknown player disconnected: " + to_json({
			"peer_id": peer_id,
			"status": "disconnected",
			"error": "Unknown player"
		}))
		emit_signal("player_data_changed")

# Allgemeine Logfunktion
func custom_log(message: String):
	emit_signal("log_message", message)  # Log-Signal an ServerConsole

# Spieler-Daten abrufen (z.B. für die Console)
func get_all_player_data() -> Dictionary:
	return player_data

# JSON Konvertierungshilfe
func to_json(data: Dictionary) -> String:
	var json = JSON.new()
	return json.stringify(data)
