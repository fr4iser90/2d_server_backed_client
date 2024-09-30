extends Node

var multiplayer_peer: WebSocketMultiplayerPeer

@onready var server_auth_manager = $"../../../Database/Server/ServerManager"
@onready var user_manager = $"../../../Database/User/UserManager"
@onready var character_manager = $"../../../Database/Character/CharacterManager"

@export var port: int = 3500

func _ready():
	multiplayer_peer = WebSocketMultiplayerPeer.new()
	var err = multiplayer_peer.create_server(port, "0.0.0.0")
	
	if err != OK:
		print("Failed to start WebSocket server on port ", port, ". Error: ", err)
		set_process(false)
	else:
		print("WebSocket server started on port ", port)

	multiplayer.multiplayer_peer = multiplayer_peer
	multiplayer_peer.connect("peer_connected", Callable(self, "_on_peer_connected"))
	multiplayer_peer.connect("peer_disconnected", Callable(self, "_on_peer_disconnected"))
	multiplayer_peer.connect("data_received", Callable(self, "_on_data_received"))

func _on_peer_connected(peer_id: int):
	print("Peer connected: ", peer_id)

func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)

func _on_data_received(peer_id: int):
	var packet = multiplayer_peer.get_packet().get_string_from_utf8()
	print("Received from peer ", peer_id, ": ", packet)

	var json = JSON.new()
	var parsed_data = json.parse(packet)
	if parsed_data.error == OK:
		var json_data = parsed_data.result
		if json_data.has("server_key"):
			server_auth_manager.authenticate_server(peer_id, json_data["server_key"])
		elif json_data.has("user_data"):
			user_manager.handle_user_data(peer_id, json_data["user_data"])
		elif json_data.has("character_data"):
			character_manager.handle_character_data(peer_id, json_data["character_data"])
		else:
			print("Invalid data received from peer ", peer_id)
	else:
		print("Error parsing packet: ", parsed_data.error_string)

func _process(_delta):
	multiplayer_peer.poll()
