# Websocket
extends Node

var reconnection_attempts = 0
var max_reconnection_attempts = 5
var reconnection_delay = 3.0

var ip = ""
var port = ""
var database_server_auth_handler
var database_user_login_handler
var database_character_fetch_handler
var websocket_multiplayer_peer: WebSocketMultiplayerPeer
var is_connected = false

func connect_to_server(ip_input: String, port_input: String, token: String):
	# Convert "localhost" to "127.0.0.1"
	ip = ip_input
	if ip_input.to_lower() == "localhost":
		ip = "127.0.0.1"
	
	# Ensure no "http://" or "https://" is in the IP string
	if ip.begins_with("http://") or ip.begins_with("https://"):
		ip = ip.substr(ip.find("/") + 2)  # Remove the protocol
	port = port_input
	database_server_auth_handler = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModuleService", "DatabaseServerAuthService")
	database_user_login_handler = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModuleService", "DatabaseUserLoginService")
	database_character_fetch_handler = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModuleService", "DatabaseCharacterFetchService")
	websocket_multiplayer_peer = WebSocketMultiplayerPeer.new()
	var url = "ws://" + ip + ":" + str(port_input)
	var err = websocket_multiplayer_peer.create_client(url)

	if err != OK:
		print("Failed to connect to WebSocket server. Error: " + str(err), self)
		return
	else:
		print("Attempting to connect to WebSocket server: " + url)

	var status_timer = Timer.new()
	status_timer.wait_time = 2.0
	status_timer.autostart = true
	status_timer.one_shot = false
	status_timer.name = "status_timer"
	status_timer.connect("timeout", Callable(self, "_check_connection_status"))
	add_child(status_timer)
	status_timer.start()
	print("status_timer :", status_timer)
	
	
func _process(delta):
	if websocket_multiplayer_peer:
		websocket_multiplayer_peer.poll()
		
		if websocket_multiplayer_peer.get_available_packet_count() > 0:
			_check_connection_status()
			_handle_incoming_message()
		
# Timer callback to check connection status every 2 seconds
func _check_connection_status():
		# Check the connection status
		var status = websocket_multiplayer_peer.get_connection_status()
		match status:
			0:
				if is_connected:
					print("Connection lost or disconnected.")
					is_connected = false
			1:
				print("Connecting...")
			2:
				if not is_connected:
					print("Connection established")
					is_connected = true
					reconnection_attempts = 0
					_on_connection_established()
			3:
				print("Error - Failed to Connect")
				is_connected = false
				_attempt_reconnection()
				
func _attempt_reconnection():
	if reconnection_attempts < max_reconnection_attempts:
		reconnection_attempts += 1
		print("Attempting to reconnect... (Attempt " + str(reconnection_attempts) + "/" + str(max_reconnection_attempts) + ")")
		
		var reconnection_timer = Timer.new()
		reconnection_timer.wait_time = reconnection_delay
		reconnection_timer.one_shot = true
		reconnection_timer.connect("timeout", Callable(self, "_reconnect_to_server"))
		add_child(reconnection_timer)
		reconnection_timer.start()
	else:
		print("Max reconnection attempts reached. Giving up.")

func _reconnect_to_server():
	print("Reconnecting to WebSocket server...")
	connect_to_server(ip, port, "")  # Reuse the last known IP and port
			
func _on_connection_established():
	print("Connected to WebSocket server at " + ip + ":" + str(port))
	
	# Send server authentication request
	if database_server_auth_handler:
		database_server_auth_handler.authenticate_server()

# Function to send data to server
func send_data_to_server(data: Dictionary):
	if is_connected:
		var websocket_peer_id = websocket_multiplayer_peer.get_unique_id()
		var json_str = JSON.stringify(data)
		websocket_multiplayer_peer.set_target_peer(1)  # Target the server (peer ID 1)
		websocket_multiplayer_peer.put_packet(json_str.to_utf8_buffer())
		print("Sending data to server: ", json_str, " with  PeerId : ", websocket_peer_id)
	else:
		print("Not connected to the server, cannot send data", self)

# Helper function to return the peer instance
func get_websocket_peer() -> WebSocketMultiplayerPeer:
	if websocket_multiplayer_peer and is_connected:
		return websocket_multiplayer_peer
	else:
		return null


# Function to handle incoming packets from the server
func _handle_incoming_message():
	var packet = websocket_multiplayer_peer.get_packet().get_string_from_utf8()
	print("Received packet from server:", packet)  # Debug-Print
	var json = JSON.new()
	var parse_result = json.parse(packet)
	if parse_result == OK:
		var message_data = json.get_data()
		_process_packet(message_data)
	else:
		print("Error parsing packet: " + json.error_string)

# Function to process different packet types
func _process_packet(packet: Dictionary):
	match packet.get("type", null):
		"server_auth_response":
			database_server_auth_handler.handle_incoming_message(packet)
		"user_auth":
			database_user_login_handler.handle_user_auth(packet)
		"fetch_all_characters":
			database_character_fetch_handler.handle_all_character_for_user(packet)
#		"player_position":
#			packet_manager.handle_player_position(peer_id, result)
#		"combat_event":
#			packet_manager.handle_combat_event(peer_id, result)
#		"chat_message":
#			packet_manager.handle_chat_message(peer_id, result)
#		"inventory_update":
#			packet_manager.handle_inventory_update(peer_id, result)
#		"quest_update":
#			packet_manager.handle_quest_update(peer_id, result)
#		"instance_change":
#			packet_manager.handle_instance_change(peer_id, result)
#		"world_change":
#			packet_manager.handle_world_change(peer_id, result)
#		"server_message":
#			packet_manager.handle_server_message(peer_id, result)
#		"sync_status":
#			packet_manager.handle_sync_status(peer_id, result)
#		"error_message":
#			packet_manager.handle_error_message(peer_id, result)
		_:
			print("Unknown packet type received: ", packet.get("type", null))

# Handler for server authentication response
func _handle_server_auth_response(packet: Dictionary):
	if packet.get("auth_status") == "success":
		print("Server authenticated successfully.")
	else:
		print("Server authentication failed.")

# Handler for player position updates
func _handle_player_position(packet: Dictionary):
	var position = packet.get("position")
	print("Player position received: ", position)

# Handler for chat messages
func _handle_chat_message(packet: Dictionary):
	var message = packet.get("message")
	print("Chat message received: ", message)
