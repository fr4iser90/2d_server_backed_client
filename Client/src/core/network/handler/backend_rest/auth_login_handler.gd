# res://src/core/network/handler/backend_rest/auth_login_handler.gd (Client)
extends Node

# Signal für erfolgreichen Login
signal login_success(username: String)
signal login_failed(reason: String)

var is_logged_in = false
var logged_in_user = ""
var user_backend_token =""
var handler_name = "auth_login_handler"
var network_module = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var user_session_manager = null
var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	network_module = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "network_module")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	is_initialized = true

# Diese Funktion wird aufgerufen, wenn ein Paket über Kanal 20 empfangen wird
func handle_packet(data: Dictionary):
	#print(data)
	if data.has("status") and data["status"] == "error":
		# Handle error message sent from the server
		print("Login failed, reason: ", data["message"])
		emit_signal("login_failed", data["message"])
		return

	if data.has("token") and data.has("user_id"):
		# Token und User-ID vom Backend erhalten
		print("Login successful. User ID: ", data["user_id"])

		# Anmeldestatus auf true setzen
		is_logged_in = true
		logged_in_user = data["user_id"]
		user_backend_token = data["token"]
		# Signal für erfolgreichen Login senden
		user_session_manager.set_auth_token(user_backend_token)
		user_session_manager.set_user_id(logged_in_user)
		emit_signal("login_success", data["user_id"], data["token"], data.get("role", ""))
	else:
		# Wenn das Paket nicht die erwarteten Daten enthält, gilt der Login als fehlgeschlagen
		print("Login failed, invalid data received.")
		emit_signal("login_failed", "Invalid data received")
		
func login(username: String, password: String):
	var enet_peer = enet_client_manager.get_enet_peer()
	if not enet_peer:
		print("ENetPeer is not initialized. Retrying in 0.1 seconds.")
		await get_tree().create_timer(0.1).timeout
		login(username, password)
		return

	# Erstelle das Login-Paket
	var login_data = {
		"username": username,
		"password": password
	}

	var err = enet_client_manager.send_packet(handler_name, login_data)
	if err != OK:
		print("Failed to send packet:", err)
	else:
		print("Login packet sent successfully")
