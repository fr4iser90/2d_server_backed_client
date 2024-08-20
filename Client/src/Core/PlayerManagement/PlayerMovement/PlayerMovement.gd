extends CharacterBody2D  # Verwende CharacterBody2D als Basisklasse

var speed = 200  # Geschwindigkeit des Charakters
var last_velocity = Vector2.ZERO  # Variable, um die letzte velocity zu speichern
var last_position = Vector2.ZERO  # Deklaration und Initialisierung von last_position

func _ready():
	print("PlayerMovement script is ready")
	last_position = global_position  # Initialisiere last_position mit der aktuellen Position

func _process(delta):
	handle_input()  # Behandle Eingaben
	move_and_slide()  # Bewege den Charakter basierend auf velocity
	
	# Überprüfe, ob sich die Position geändert hat
	if global_position != last_position:
		print("Position changed to: ", global_position)
		last_position = global_position  # Aktualisiere die letzte Position
		send_movement_to_server()  # Sende die Bewegung an den Server

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
		last_velocity = velocity  # Update last_velocity nur, wenn sich velocity ändert

func send_movement_to_server():
	var movement_data = {
		"position": global_position,
		"velocity": velocity,
	}
	
	var message_str = JSON.stringify(movement_data)
	print("Movement Data to Send: ", movement_data)  # Debug-Ausgabe
	var packet = message_str.to_utf8_buffer()
	
	if multiplayer.get_multiplayer_peer() is ENetMultiplayerPeer:
		multiplayer.send_bytes(packet, 1)  # Send data over channel 1
	else:
		print("Error: ENet peer not found or not initialized.")

