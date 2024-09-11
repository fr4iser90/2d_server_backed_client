extends Enemy

@onready var hitbox: Area2D = get_node("Hitbox")

signal velocity_updated(velocity: Vector2)

func _process(_delta: float) -> void:
	hitbox.knockback_direction = velocity.normalized()
	emit_signal("velocity_updated", velocity)
