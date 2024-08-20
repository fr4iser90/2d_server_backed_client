extends Node

signal connected_to_server

var enet_peer: ENetMultiplayerPeer
var other_players = {}  # Dictionary to store other players

func _ready():
	connect_to_server("127.0.0.1", 9997)

func connect_to_server(address: String, port: int):
	enet_peer = ENetMultiplayerPeer.new()
	var err = enet_peer.create_client(address, port)
	
	if err == OK:
		# Verwende einen deferred Call, um sicherzustellen, dass die Zuweisung erfolgt, wenn der Baum bereit ist
		call_deferred("_set_network_peer")
	else:
		print("Failed to connect to server: ", err)
		enet_peer = null

func _set_network_peer():
	if enet_peer:
		print("Setting network peer...")
		var multiplayer_api = get_tree().get_multiplayer()
		multiplayer_api.set_multiplayer_peer(enet_peer)
		print("Network peer set successfully.")
		
		# Verbinde das Signal mit der Methode in ClientMain
		var client_main = get_tree().get_root().get_node("ClientMain")
		if client_main:
			connect("connected_to_server", Callable(client_main, "_on_connected_to_server"))
			print("Signal 'connected_to_server' connected to ClientMain")
		
		# Signal senden, um den nächsten Schritt einzuleiten
		emit_signal("connected_to_server")
		print("Signal 'connected_to_server' emitted")
	else:
		print("Network peer is not valid.")

func _process(delta):
	if enet_peer and enet_peer.get_connection_status() == ENetMultiplayerPeer.CONNECTION_CONNECTED:
		enet_peer.poll()
		while enet_peer.get_available_packet_count() > 0:
			var packet = enet_peer.get_packet()
			var packet_peer_id = enet_peer.get_packet_peer()

			match enet_peer.get_packet_channel():
				1:  # Movement data channel
					if packet.size() > 0:
						print("Received packet from peer: ", packet_peer_id)
						var message = packet.get_string_from_utf8()

						# Debug: Output raw data to identify issues
						print("Raw packet data: ", message)

						var json = JSON.new()
						var parse_result = json.parse(message)

						if parse_result == OK:
							var movement_data = json.get_data()
							update_other_player_position(movement_data)
						else:
							print("Failed to parse JSON ENET data: ", message)
					else:
						print("Received empty or non-UTF-8 packet from peer: ", packet_peer_id)

func update_other_player_position(movement_data: Dictionary):
	if not movement_data.has("peer_id") or not movement_data.has("position"):
		print("Invalid movement data: ", movement_data)
		return

	var peer_id = movement_data["peer_id"]
	var position = movement_data["position"]

	if not other_players.has(peer_id):
		var new_player = load("res://src/Data/Characters/Players/Knight/Knight.tscn").instance()
		add_child(new_player)
		other_players[peer_id] = new_player

	var player = other_players[peer_id]
	player.global_position = position
