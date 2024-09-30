extends Node

var websocket_multiplayer_peer: WebSocketMultiplayerPeer

@onready var server_auth_manager = $"../../../Database/Server/ServerManager"
@onready var user_manager = $"../../../Database/User/UserManager"
@onready var character_manager = $"../../../Database/Character/CharacterManager"

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

func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)

func _process(_delta):
	websocket_multiplayer_peer.poll()
	if websocket_multiplayer_peer.get_available_packet_count() > 0:
		print("Packet available for reading")
		var packet = websocket_multiplayer_peer.get_packet().get_string_from_utf8()
		print("Received packet:", packet)
		_handle_received_packet(packet)




func _handle_received_packet(packet):
	var json = JSON.new()
	var error_code = json.parse(packet)  # Parsing the packet
	var parsed_data = json.result  # Accessing the parsed result
	
	if error_code == OK:
		var json_data = parsed_data  # parsed_data is the actual parsed JSON dictionary
		if json_data.has("server_key"):
			server_auth_manager.authenticate_server(json_data["server_key"])
		elif json_data.has("user_data"):
			user_manager.handle_user_data(json_data["user_data"])
		elif json_data.has("character_data"):
			character_manager.handle_character_data(json_data["character_data"])
		else:
			print("Invalid data received")
	else:
		print("Error parsing packet: ", json.error_string)



