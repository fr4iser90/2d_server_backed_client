extends CharacterBody2D

# Movement properties
var speed = 200
var last_velocity = Vector2.ZERO
var last_position = Vector2.ZERO

# Networking
var other_players = {}
var network_manager = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var client_main = null

# Initialization flag
var is_initialized = false

func _ready():
	initialize()
	last_position = global_position
	if _check_client_ready():
		_on_connected_to_server()
	else:
		print("Client main or enet_client_manager is not ready, waiting for connection...")

func initialize():
	if is_initialized:
		print("Already initialized.")
		return

	# Retrieve global nodes
	network_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	client_main = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "client_main")
	
	if network_manager == null or enet_client_manager == null or channel_manager == null or packet_manager == null or client_main == null:
		print("Error: One or more nodes could not be retrieved.")
	else:
		is_initialized = true
		print("Initialization complete.")

func _check_client_ready() -> bool:
	# Check if the client_main and enet_client_manager are ready
	if client_main:
		print("Client main found.")
	else:
		print("Client main not found.")
		
	if enet_client_manager:
		print("EnetClientManager found.")
		enet_client_manager.connect("network_peer_packet_received", Callable(self, "_on_network_peer_packet_received"))
		return true
	else:
		print("EnetClientManager not found.")
		return false

func _process(delta):
	if client_main == null or not client_main.is_connected:
		print("Waiting for connection...")
		return

	handle_input()
	move_and_slide()

	if global_position != last_position:
		print("Position changed to: ", global_position)
		last_position = global_position
		send_movement_to_server()

func _on_connected_to_server():
	if client_main and not client_main.is_connected:
		print("Connected to server. Ready to send and receive data.")
		client_main.is_connected = true
	else:
		print("Already connected or client_main is null.")

func _on_network_peer_packet_received(id: int, packet: PacketPeer):
	print("Packet received from peer: ", id)
	var message_str = packet.get_string_from_utf8()
	var movement_data = JSON.parse_string(message_str)
	
	if movement_data.error == OK:
		if movement_data.result["peer_id"] != get_tree().get_multiplayer().get_unique_id():
			update_other_player_position(movement_data.result)
		else:
			print("Ignoring packet from self.")
	else:
		print("Failed to parse JSON: ", movement_data.error)

func update_other_player_position(movement_data: Dictionary):
	if not movement_data.has("peer_id") or not movement_data.has("position"):
		print("Invalid movement data: ", movement_data)
		return

	var peer_id = movement_data["peer_id"]
	var position = movement_data["position"]

	if other_players.has(peer_id):
		var player = other_players[peer_id]
		player.global_position = position
	else:
		print("No existing player found for ID: ", peer_id)

func handle_input():
	var new_velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		new_velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		new_velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		new_velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		new_velocity.y -= 1

	if new_velocity != Vector2.ZERO:
		new_velocity = new_velocity.normalized() * speed

	velocity = new_velocity

	if velocity != last_velocity:
		print("Velocity changed to: ", velocity)
		last_velocity = velocity

func send_movement_to_server():
	if enet_client_manager:
		var handler_name = "player_movement_handler"
		var movement_data = {
			"position": global_position,
			"velocity": velocity,
			"peer_id": enet_client_manager.get_peer_id(), 
		}

		var err = enet_client_manager.send_packet(handler_name, movement_data)
		if err != OK:
			print("Failed to send packet:", err)
	else:
		print("ENet client instance is not valid, cannot send packet.")
