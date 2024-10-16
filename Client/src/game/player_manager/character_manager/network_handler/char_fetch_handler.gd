# res://src/core/network/handler/backend_rest/char_fetch_handler.gd (Client)
extends Node

# Signal für erfolgreiches Abrufen der Charakterdaten
signal characters_fetched(character_data: Array)
signal characters_fetch_failed(reason: String)

var network_module = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var user_session_manager = null
var handler_name = "CharacterFetchService"
var is_initialized = false


func initialize():
	if is_initialized:
		return

	network_module = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	is_initialized = true

# Diese Funktion wird aufgerufen, wenn ein Paket über Kanal 21 empfangen wird
func handle_packet(data: Dictionary):
	if data.has("characters"):
		print("data", data)
		emit_signal("characters_fetched", data["characters"])
	else:
		print("Character fetch failed, invalid data received.")
		emit_signal("characters_fetch_failed", "Invalid data received")

# Diese Funktion sendet eine Anfrage an den Server, um die Charakterdaten zu erhalten
func fetch_characters():
	# Get the session token from the UserSessionManager
	var session_token = user_session_manager.get_session_token()
	var enet_peer = enet_client_manager.get_enet_peer()

	if not enet_peer:
		print("ENetPeer is not initialized. Retrying in 0.1 seconds.")
		await get_tree().create_timer(0.1).timeout
		fetch_characters()
		return

	# Create the request data to fetch characters using the session token
	var request_data = {
		"session_token": session_token
	}

	var err = enet_client_manager.send_packet(handler_name, request_data)
	if err != OK:
		print("Failed to send packet:", err)
	else:
		print("Character fetch packet sent successfully")
