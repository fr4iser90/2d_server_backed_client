extends Node

var enet_peer: ENetMultiplayerPeer
var player_movement_manager
var player_names = {}

func start_server(port: int):
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_server(port, 32)
	multiplayer.multiplayer_peer = enet_peer
	print("Server listening on port ", port)
	set_process(true)

func _ready():
	# Überprüfe, ob player_movement_manager korrekt zugewiesen wird
	player_movement_manager = get_parent().player_movement_manager
	if not player_movement_manager:
		print("PlayerMovementManager not found!")  # Debugging-Ausgabe

func _process(delta):
	if enet_peer:
		enet_peer.poll()
		while enet_peer.get_available_packet_count() > 0:
			var packet = enet_peer.get_packet()
			var packet_peer_id = enet_peer.get_packet_peer()
			var packet_channel = enet_peer.get_packet_channel()
			print("Received packet from peer_id: ", packet_peer_id, " on channel: ", packet_channel)
			match packet_channel:
				0:
					handle_connection(packet_peer_id)
				1:
					handle_data(packet_peer_id, packet)
				2:
					handle_disconnection(packet_peer_id)

func handle_connection(peer_id: int):
	print("Handling connection for peer_id: ", peer_id)
	Log.log_player_connected(peer_id)
	send_initial_data_to_client(peer_id)

func handle_data(peer_id: int, packet: PackedByteArray):
	print("Handling data from peer_id: ", peer_id)
	print("Received packet: ", packet)
	if player_movement_manager:
		player_movement_manager.process_received_data(peer_id, packet)
	else:
		print("PlayerMovementManager not found!")

func handle_disconnection(peer_id: int):
	print("Player disconnected: ", peer_id)
	Log.log_player_disconnected(peer_id)
	if player_movement_manager:
		player_movement_manager.remove_player(peer_id)
	else:
		print("PlayerMovementManager not found!")

func send_initial_data_to_client(peer_id: int):
	if player_movement_manager:
		var all_players_data = player_movement_manager.get_all_players_data()
		send_data_to_client(peer_id, all_players_data)

func send_data_to_client(peer_id: int, data: Dictionary):
	var message_str = JSON.stringify(data)
	var packet = message_str.to_utf8_buffer()
	
	# Debugging-Ausgabe
	print("Sending data to peer: ", peer_id)
	print("Data: ", data)
	print("Serialized message: ", message_str)
	
	if enet_peer:
		var result = enet_peer.send_packet(packet, 0, peer_id, true)
		if result:
			print("Data sent successfully to peer: ", peer_id)
		else:
			print("Failed to send data to peer: ", peer_id)
	else:
		print("ENet peer is not initialized.")

# RPC-Methode zum Aktualisieren der Spielerbewegung
@rpc
func update_player_movement(peer_id: int, position: Vector2, velocity: Vector2):
	if player_movement_manager:
		var movement_data = {
			"position": JSON.stringify({"x": position.x, "y": position.y}),
			"velocity": JSON.stringify({"x": velocity.x, "y": velocity.y})
		}
		player_movement_manager.process_movement_data(peer_id, movement_data)
	else:
		print("PlayerMovementManager not found!")

@rpc
func set_player_name(peer_id: int, player_name: String):
	player_names[peer_id] = player_name
	print("Player name set for peer_id ", peer_id, ": ", player_name)
