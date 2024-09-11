extends Hitbox

var enemy_exited: bool = false

var direction: Vector2 = Vector2.ZERO
var knife_speed: int = 0


func launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	if is_multiplayer_authority():  # Nur auf dem Server
		# Initialisiere die Position und Bewegung
		position = initial_position
		direction = dir
		knockback_direction = dir
		knife_speed = speed

		rotation += dir.angle() + PI/4

		# Synchronisiere den Start mit den Clients
		rpc("sync_launch", initial_position, dir, speed)

func sync_launch(initial_position: Vector2, dir: Vector2, speed: int) -> void:
	# Setze die Messerposition und -bewegung auf den Clients
	position = initial_position
	direction = dir
	knife_speed = speed

	rotation += dir.angle() + PI/4


func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():  # Nur auf dem Server
		position += direction * knife_speed * delta
		# Synchronisiere die Position mit den Clients
		rpc("sync_position", position)

func sync_position(new_position: Vector2) -> void:
	# Aktualisiere die Position auf den Clients
	position = new_position


func _on_ThrowableKnike_body_exited(_body: Node2D) -> void:
	if is_multiplayer_authority() and not enemy_exited:  # Nur auf dem Server
		enemy_exited = true
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
		set_collision_mask_value(4, true)
		# Synchronisiere die Kollisionsmaske mit den Clients
		rpc("sync_collision_mask", true)

func sync_collision_mask(value: bool) -> void:
	# Aktualisiere die Kollisionsmaske auf den Clients
	set_collision_mask_value(1, value)
	set_collision_mask_value(2, value)
	set_collision_mask_value(3, value)
	set_collision_mask_value(4, value)


func _collide(body: Node2D) -> void:
	if enemy_exited:
		if body.has_method("take_damage"):
			body.take_damage(damage, knockback_direction, knockback_force)
		queue_free()
