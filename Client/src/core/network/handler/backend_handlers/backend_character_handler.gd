# res://src/core/network/handler/backend_handlers/backend_character_handler.gd
extends Node

# Signal für erfolgreiches Abrufen der Charakterdaten
signal characters_fetched(character_data: Array)
signal characters_fetch_failed(reason: String)

var network_manager = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var handler_name = "backend_character_handler"
var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_characters already initialized. Skipping.")
		return

	network_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true

# Diese Funktion wird aufgerufen, wenn ein Paket über Kanal 21 empfangen wird
func handle_packet(data: Dictionary, peer_id: int):
	if data.has("characters"):
		# Charakterdaten wurden empfangen
		print("Character data received: ", data["characters"])
		GlobalManager.GlobalConfig.set_character_list(data["characters"])
		# Signal für erfolgreiches Abrufen der Charaktere senden
		emit_signal("characters_fetched", data["characters"])
	else:
		# Fehlermeldung, wenn die Daten nicht korrekt sind
		print("Character fetch failed, invalid data received.")
		emit_signal("characters_fetch_failed", "Invalid data received")

# Diese Funktion sendet eine Anfrage an den Server, um die Charakterdaten zu erhalten
func fetch_characters():
	# Token und Benutzer-ID aus der GlobalConfig holen
	var token = GlobalManager.GlobalConfig.get_auth_token()
	var user_id = GlobalManager.GlobalConfig.get_user_id()
	var enet_peer = enet_client_manager.get_enet_peer()
	if not enet_peer:
		print("ENetPeer is not initialized. Retrying in 0.1 seconds.")
		await get_tree().create_timer(0.1).timeout
		fetch_characters()
		return

	# Erstelle das Paket mit dem Token, um die Charakterdaten abzurufen
	var request_data = {
		"token": token
	}

	var err = enet_client_manager.send_packet(handler_name, request_data)
	if err != OK:
		print("Failed to send packet:", err)
	else:
		print("Character fetch packet sent successfully")
