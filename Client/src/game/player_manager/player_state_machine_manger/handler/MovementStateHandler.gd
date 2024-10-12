extends CharacterBody2D

var player = null  # Reference to the CharacterBody2D player node
var speed = 200
var speed_multiplier = 2.5  # Multiplikator für Bewegungsgeschwindigkeit
var last_velocity = Vector2.ZERO
var last_position = Vector2.ZERO
var movement_player_handler = null
var enet_client_manager = null
var player_peer_id = -1

# Set the player node when entering the state
func enter_state(player_node: CharacterBody2D, peer_id: int):
	print("Entering movement state for player: ", player_node)
	player = player_node  # Set the player node here
	player_peer_id = peer_id
	
	if player:
		last_position = player.global_position
		print("Player's initial position: ", last_position)
	else:
		print("Warning: player node is null when entering movement state.")
	
	# Get the movement player handler and connect signals
	movement_player_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "MovementPlayerService")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	if movement_player_handler and enet_client_manager.get_peer_id() == player_peer_id:
		print("Connecting to movement_player_handler for local player")
		movement_player_handler.connect("position_received", Callable(self, "update_other_player_position"))

# Called when exiting the movement state
func exit_state():
	print("Exiting movement state for player")
	if movement_player_handler and enet_client_manager.get_peer_id() == player_peer_id:
		# Disconnect the signal to avoid leaks
		if movement_player_handler.is_connected("position_received", Callable(self, "update_other_player_position")):
			print("Disconnecting from movement_player_handler")
			movement_player_handler.disconnect("position_received", Callable(self, "update_other_player_position"))

# Handle the movement logic in update_state (called in _process from the state manager)
func update_state(delta):
	if player == null:
		print("Warning: player is not set in movement state.")
		return

	# Only handle movement for the local player (based on peer_id)
	if enet_client_manager.get_peer_id() == player_peer_id:
		handle_input()
		player.move_and_slide()

		if player.global_position != last_position:
			last_position = player.global_position
			send_movement()  # Only send movement for the local player

# Handle player input
func handle_input():
	var new_velocity = Vector2.ZERO
	
	# Check for input
	if Input.is_action_pressed("ui_right"):
		new_velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		new_velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		new_velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		new_velocity.y -= 1

	if new_velocity != Vector2.ZERO:
		# Wende den Geschwindigkeitsmultiplikator an
		new_velocity = new_velocity.normalized() * speed * speed_multiplier
	
	player.velocity = new_velocity
	
# Send movement data to the server
func send_movement():
	if movement_player_handler and enet_client_manager.get_peer_id() == player_peer_id:
		movement_player_handler.send_movement_data(player.global_position, player.velocity)

# Update position for other players
func update_other_player_position(peer_id: int, position: Vector2, velocity: Vector2):
	if peer_id != player_peer_id and player:
		player.global_position = position
		player.velocity = velocity
