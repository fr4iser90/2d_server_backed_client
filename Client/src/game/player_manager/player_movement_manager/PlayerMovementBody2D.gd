# res://src/game/player_manager/player_movement_manager/PlayerMovementBody2D.gd
extends CharacterBody2D

var speed = 200
var last_velocity = Vector2.ZERO
var last_position = Vector2.ZERO
var movement_player_handler
var local_player = true  # Assuming this is always true for local players

func _ready():
	# Get the movement manager
	movement_player_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "MovementPlayerService")
	last_position = global_position

	# Connect to position updates for other players
	if movement_player_handler:
		movement_player_handler.connect("position_received", Callable(self, "update_other_player_position"))

func _process(delta):
	handle_input()
	move_and_slide()

	# Send movement data to the server without position tolerance
	if global_position != last_position:
		last_position = global_position
		send_movement()

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
		last_velocity = velocity

# Function to send movement data to the server
func send_movement():
	if movement_player_handler:
		print("Sending movement data to the server")
		movement_player_handler.send_movement_data(global_position, velocity)
	else:
		print("No movement_player_handler available")

# Update position for other players
func update_other_player_position(peer_id: int, position: Vector2, velocity: Vector2):
	if not local_player:  # Only update if this is not the local player
		print("Updating position for peer_id: ", peer_id, " to position: ", position, " with velocity: ", velocity)
		global_position = position
		self.velocity = velocity
