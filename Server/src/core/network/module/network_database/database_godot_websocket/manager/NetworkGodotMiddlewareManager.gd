# NetworkMiddlewareManager
extends Node

var ip = "127.0.0.1"
var port = "3500"
var network_endpoint_manager
var database_server_auth_handler
var websocket_multiplayer_peer: WebSocketMultiplayerPeer
var is_connected = false

# Connect the signal when the node enters the scene tree
func _ready():
	network_endpoint_manager = GlobalManager.NodeManager.get_cached_node("network_database_module", "network_endpoint_manager")
	database_server_auth_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_server_auth_handler")
	# Initiate connection to the server
	connect_to_server()

	# Create and start a Timer for checking the connection status every 2 seconds
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_check_connection_status"))
	add_child(timer)

func connect_to_server():
	websocket_multiplayer_peer = WebSocketMultiplayerPeer.new()
	var url = "ws://" + ip + ":" + str(port)
	var err = websocket_multiplayer_peer.create_client(url)
	multiplayer.multiplayer_peer = websocket_multiplayer_peer
	if err != OK:
		print("Failed to connect to WebSocket server. Error: " + str(err), self)
		return
	else:
		print("Attempting to connect to WebSocket server: " + url, self)
		


# Timer callback to check connection status every 2 seconds
func _check_connection_status():
	if websocket_multiplayer_peer:
		websocket_multiplayer_peer.poll()  # Continue polling the peer

		# Check the connection status
		var status = websocket_multiplayer_peer.get_connection_status()
		#print("Checking WebSocket peer - Connection Status: ", status)
		
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
					_on_connection_established()
			3:
				print("Error - Failed to Connect")
				is_connected = false

func _on_connection_established():
	print("Connected to WebSocket server at " + ip + ":" + str(port))
	var test_data = {"test_key": "test_value"}
	send_data_to_server(test_data)
	# Here you can trigger any additional logic that should happen when connected
	if database_server_auth_handler:
		database_server_auth_handler.authenticate_server()
	
func send_data_to_server(data: Dictionary):
	if is_connected:
		var websocket_multiplayer_peer_id = websocket_multiplayer_peer.get_unique_id()
		var json_str = JSON.stringify(data)
		
		# Send actual data
		#websocket_multiplayer_peer.put_packet(json_str.to_utf8_buffer())
		
		
		var test_data2 = "HelloServer"
		print("Sending test data: ", test_data2)
		websocket_multiplayer_peer.put_packet(test_data2.to_utf8_buffer())		
		# Create simple test data as an additional packet
		var test_data = {"test_key": "test_value"}
		var test_data_str = JSON.stringify(test_data)
		
		# Send the test data packet
		websocket_multiplayer_peer.put_packet(test_data_str.to_utf8_buffer())
		
		print("Message:", data, "is sent via ID:", websocket_multiplayer_peer_id)
		print("Test data sent:", test_data)
		
		# Test sending various packet types
		_test_packet_types()
	else:
		print("Not connected to the server, cannot send data", self)

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



func get_websocket_peer() -> WebSocketMultiplayerPeer:
	if websocket_multiplayer_peer and is_connected:
		return websocket_multiplayer_peer
	else:
		return null
