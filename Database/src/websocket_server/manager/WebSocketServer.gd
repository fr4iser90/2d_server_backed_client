extends Node

# Server variables
var websocket_multiplayer_peer: WebSocketMultiplayerPeer
var peers_info = {}  # Stores information for each peer, such as packet counts.

@export var port: int = 3500
@onready var peer_list = $"../../../../Control/MainVBoxContainer/MainHBoxContainer/ListContainer/PeerPanel/PeerList"
@onready var packet_manager = $PacketManager

# Initial setup of the WebSocket server
func _ready():
	initialize_server()

# Initializes WebSocket server
func initialize_server():
	websocket_multiplayer_peer = WebSocketMultiplayerPeer.new()
	var err = websocket_multiplayer_peer.create_server(port, "0.0.0.0")

	if err != OK:
		print("Failed to start WebSocket server on port ", port, ". Error: ", err)
		set_process(false)
	else:
		print("WebSocket server started on port ", port)
		websocket_multiplayer_peer.connect("peer_connected", Callable(self, "_on_peer_connected"))
		websocket_multiplayer_peer.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))

# Handle a new peer connecting
func _on_peer_connected(peer_id: int):
	print("Peer connected: ", peer_id)
	_register_peer(peer_id)
	_send_welcome_message(peer_id)

# Registers peer information (packet counts)
func _register_peer(peer_id: int):
	peers_info[peer_id] = {"sent_packets": 0, "received_packets": 0}
	peer_list.add_item("Peer ID: " + str(peer_id) + " | Packets Sent: 0 | Packets Received: 0")

# Sends a welcome message to a new peer
func _send_welcome_message(peer_id: int):
	var welcome_message = {"type": "greeting", "message": "Welcome to the server, Peer ID: " + str(peer_id)}
	_send_json_to_peer(peer_id, welcome_message)
	peers_info[peer_id]["sent_packets"] += 1
	_update_peer_list(peer_id)

# Handle peer disconnection
func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)
	_unregister_peer(peer_id)

# Unregisters and removes peer info from the UI
func _unregister_peer(peer_id: int):
	peers_info.erase(peer_id)
	for i in range(peer_list.get_item_count()):
		if peer_list.get_item_text(i).find(str(peer_id)) != -1:
			peer_list.remove_item(i)
			break

# Process WebSocket events and poll for packets
func _process(delta):
	websocket_multiplayer_peer.poll()
	if websocket_multiplayer_peer.get_available_packet_count() > 0:
		_handle_incoming_packet()

# Handle incoming packets
func _handle_incoming_packet():
	var peer_id = websocket_multiplayer_peer.get_packet_peer()
	var packet = websocket_multiplayer_peer.get_packet().get_string_from_utf8()
	print("Received packet from peer ", peer_id, ": ", packet)

	# Increment received packets count and update peer info
	if peer_id in peers_info:
		peers_info[peer_id]["received_packets"] += 1
		_update_peer_list(peer_id)
	_handle_received_packet(packet, peer_id)

# Parses and processes the received packet (JSON format)
func _handle_received_packet(packet: String, peer_id: int):
	var json = JSON.new()
	var parse_result = json.parse(packet)

	if parse_result == OK:
		var result = json.get_data()
		var packet_type = result.get("type", null)

		# Look for the appropriate handler in the packet_handlers dictionary
		if packet_manager.packet_handlers.has(packet_type):
			var handler = packet_manager.packet_handlers[packet_type]
			handler.call(peer_id, result)  # Call the handler dynamically
		else:
			print("Unrecognized packet type received from peer ", peer_id)
	else:
		print("Error parsing packet: ", json.error_string)


# Updates the peer list in the UI to show the number of sent/received packets
func _update_peer_list(peer_id: int):
	for i in range(peer_list.get_item_count()):
		if peer_list.get_item_text(i).find(str(peer_id)) != -1:
			peer_list.set_item_text(i, "Peer ID: " + str(peer_id) +
									" | Packets Sent: " + str(peers_info[peer_id]["sent_packets"]) +
									" | Packets Received: " + str(peers_info[peer_id]["received_packets"]))
			break

# Utility function to send JSON data to a specific peer
func _send_json_to_peer(peer_id: int, data: Dictionary):
	if peer_id in peers_info:
		var json_str = JSON.stringify(data)
		websocket_multiplayer_peer.set_target_peer(peer_id)
		websocket_multiplayer_peer.put_packet(json_str.to_utf8_buffer())
