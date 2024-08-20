extends Hitbox

@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	animation_player.play("pierce")

func _collide(body: Node2D) -> void:
	if is_multiplayer_authority():  # Nur auf dem Server ausführen
		if not body.flying:
			knockback_direction = (body.global_position - global_position).normalized()
			body.take_damage(damage, knockback_direction, knockback_force)
			rpc("sync_collide_on_clients", body.get_path(), knockback_direction)

@rpc
func sync_collide_on_clients(body_path: NodePath, knockback_dir: Vector2) -> void:
	# Synchronisiere die Kollision auf den Clients
	var body: Node2D = get_node(body_path)
	if body:
		if not body.flying:
			body.take_damage(damage, knockback_dir, knockback_force)
