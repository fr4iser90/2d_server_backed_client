extends Node

var ip = "127.0.0.1"
var port = "3500"
var database_server_auth_handler
var websocket_multiplayer_peer: WebSocketMultiplayerPeer
var test_packet_timer: Timer
var is_connected = false

# Connect the signal when the node enters the scene tree
func _ready():
	database_server_auth_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_server_auth_handler")
	
	connect_to_server()

	# Create a Timer for checking connection status every 2 seconds
	var status_timer = Timer.new()
	status_timer.wait_time = 2.0
	status_timer.autostart = true
	status_timer.one_shot = false
	status_timer.connect("timeout", Callable(self, "_check_connection_status"))
	add_child(status_timer)

	# Create a Timer for sending test packets every 2 seconds
	test_packet_timer = Timer.new()
	test_packet_timer.wait_time = 2.0
	test_packet_timer.autostart = false  # Only start when connection is established
	test_packet_timer.one_shot = false
	test_packet_timer.connect("timeout", Callable(self, "_send_test_packets"))
	add_child(test_packet_timer)

func connect_to_server():
	websocket_multiplayer_peer = WebSocketMultiplayerPeer.new()
	var url = "ws://" + ip + ":" + str(port)
	var err = websocket_multiplayer_peer.create_client(url)
	multiplayer.multiplayer_peer = websocket_multiplayer_peer
	if err != OK:
		print("Failed to connect to WebSocket server. Error: " + str(err), self)
		return
	else:
		print("Attempting to connect to WebSocket server: " + url)

# Timer callback to check connection status every 2 seconds
func _check_connection_status():
	if websocket_multiplayer_peer:
		websocket_multiplayer_peer.poll()  # Continue polling the peer

		# Check the connection status
		var status = websocket_multiplayer_peer.get_connection_status()
		match status:
			0:
				if is_connected:
					print("Connection lost or disconnected.")
					is_connected = false
					test_packet_timer.stop()  # Stop sending test packets
			1:
				print("Connecting...")
			2:
				if not is_connected:
					print("Connection established")
					is_connected = true
					_on_connection_established()
					test_packet_timer.start()  # Start sending test packets
			3:
				print("Error - Failed to Connect")
				is_connected = false

func _on_connection_established():
	print("Connected to WebSocket server at " + ip + ":" + str(port))
	var welcome_message = {
		"type": "greeting",
		"message": "Greetings from Client"
	}
	var json_str = JSON.stringify(welcome_message)
	var test_packet = json_str.to_utf8_buffer()

	# Set the server's peer ID as 1 (commonly used for the server in many setups)
	websocket_multiplayer_peer.set_target_peer(1) 
	websocket_multiplayer_peer.put_packet(test_packet)
	print("Sent greeting to server")
	
	if database_server_auth_handler:
		database_server_auth_handler.authenticate_server()


# Function to send data to server
func send_data_to_server(data: Dictionary):
	if is_connected:
		var json_str = JSON.stringify(data)
		websocket_multiplayer_peer.set_target_peer(1)  # Target the server (peer ID 1)
		websocket_multiplayer_peer.put_packet(json_str.to_utf8_buffer())
		print("Sending data to server:", json_str)
	else:
		print("Not connected to the server, cannot send data", self)

# Function to send test packets every 2 seconds
func _send_test_packets():
	if is_connected:
		var test_data = { "message": "Hello from the client" }
		var test_data_str = JSON.stringify(test_data)
		websocket_multiplayer_peer.put_packet(test_data_str.to_utf8_buffer())
		print("Test data sent every 2 seconds:", test_data)

# Function to test sending different types of packets
func _test_packet_types():
	var test_packets = [
		{ "type": "string", "value": "Hello, World!" },
		{ "type": "int", "value": 42 },
		{ "type": "float", "value": 3.14 },
		{ "type": "bool", "value": true },
		{ "type": "array", "value": [1, 2, 3] },
		{ "type": "dictionary", "value": { "key": "value" } }
	]
	for packet in test_packets:
		var packet_str = JSON.stringify(packet)
		websocket_multiplayer_peer.put_packet(packet_str.to_utf8_buffer())
		print("Test packet sent:", packet)

# Helper function to return the peer instance
func get_websocket_peer() -> WebSocketMultiplayerPeer:
	if websocket_multiplayer_peer and is_connected:
		return websocket_multiplayer_peer
	else:
		return null
