# SERVER
extends Node

var websocket_multiplayer_peer: WebSocketMultiplayerPeer
var peers_info = {}  # Dictionary to store information about connected peers and their packet count

@onready var peer_list = $"../../../../Control/PeerContainer/PeerPanel/PeerList"


@export var port: int = 3500

func _ready():
	websocket_multiplayer_peer = WebSocketMultiplayerPeer.new()
	var err = websocket_multiplayer_peer.create_server(port, "0.0.0.0")

	if err != OK:
		print("Failed to start WebSocket server on port ", port, ". Error: ", err)
		set_process(false)
	else:
		print("WebSocket server started on port ", port)

	multiplayer.multiplayer_peer = websocket_multiplayer_peer
	websocket_multiplayer_peer.connect("peer_connected", Callable(self, "_on_peer_connected"))
	websocket_multiplayer_peer.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))

func _on_peer_connected(peer_id: int):
	print("Peer connected: ", peer_id)

	# Add the peer to the dictionary with packet counts initialized
	peers_info[peer_id] = {
		"sent_packets": 0,
		"received_packets": 0
	}
	
	# Create a welcome message
	var welcome_message = {
		"type": "greeting",
		"message": "Welcome to the server, Peer ID: " + str(peer_id)
	}
	
	# Convert the message to JSON and then to a buffer
	var json_str = JSON.stringify(welcome_message)
	var packet_data = json_str.to_utf8_buffer()

	# Send the welcome message to the connected peer
	websocket_multiplayer_peer.set_target_peer(peer_id)
	websocket_multiplayer_peer.put_packet(packet_data)

	# Update the peer list in the UI
	peer_list.add_item("Peer ID: " + str(peer_id) + " | Packets Sent: 0 | Packets Received: 0")

	# Increment the packet count for the sent packets
	peers_info[peer_id]["sent_packets"] += 1
	_update_peer_list(peer_id)


func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)

	# Remove the peer from the dictionary
	if peer_id in peers_info:
		peers_info.erase(peer_id)
	
	# Remove the peer from the UI list
	for i in range(peer_list.get_item_count()):
		if peer_list.get_item_text(i).find(str(peer_id)) != -1:
			peer_list.remove_item(i)
			break

func _process(delta):
	websocket_multiplayer_peer.poll()

	if websocket_multiplayer_peer.get_available_packet_count() > 0:
		var packet = websocket_multiplayer_peer.get_packet().get_string_from_utf8()
		print("Received packet from peer: ", packet)


# Function to update the peer list in the UI
func _update_peer_list(peer_id):
	for i in range(peer_list.get_item_count()):
		if peer_list.get_item_text(i).find(str(peer_id)) != -1:
			peer_list.set_item_text(i, "Peer ID: " + str(peer_id) + 
									" | Packets Sent: " + str(peers_info[peer_id]["sent_packets"]) +
									" | Packets Received: " + str(peers_info[peer_id]["received_packets"]))
			break

func send_packet_to_peer(peer_id: int, packet: String):
	if peer_id in peers_info:
		# Assuming you want to send the packet to all peers
		var packet_data = packet.to_utf8_buffer()
		websocket_multiplayer_peer.put_packet(packet_data)
		# Increment the sent packet counter
		peers_info[peer_id]["sent_packets"] += 1
		_update_peer_list(peer_id)

