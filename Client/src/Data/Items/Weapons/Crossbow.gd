extends Weapon

const ARROW_SCENE: PackedScene = preload("res://Client/Weapons/Arrow.tscn")

func shoot(offset: int) -> void:
	if is_multiplayer_authority():  # Nur auf dem Server
		_spawn_arrow(global_position, rotation_degrees + offset)

func triple_shoot() -> void:
	shoot(0)
	shoot(12)
	shoot(-12)

func _spawn_arrow(start_position: Vector2, angle: float) -> void:
	var arrow: Area2D = ARROW_SCENE.instantiate()
	arrow.position = start_position
	arrow.rotation_degrees = angle
	get_tree().current_scene.add_child(arrow)
	arrow.launch(arrow.position, Vector2.LEFT.rotated(deg_to_rad(angle)), 400)
	# Synchronisiere den Schuss mit den Clients
	rpc("sync_shoot", arrow.position, angle)

@rpc
func sync_shoot(start_position: Vector2, angle: float) -> void:
	# Pfeil auf den Clients synchron spawnen
	var arrow: Area2D = ARROW_SCENE.instantiate()
	arrow.position = start_position
	arrow.rotation_degrees = angle
	get_tree().current_scene.add_child(arrow)
	arrow.launch(arrow.position, Vector2.LEFT.rotated(deg_to_rad(angle)), 400)
