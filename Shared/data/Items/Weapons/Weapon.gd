extends Node2D
class_name Weapon

@export var on_floor: bool = false
@export var ranged_weapon: bool = false
@export var rotation_offset: int = 0

var can_active_ability: bool = true
var tween: Tween = null  # Initialisierung von tween

@onready var hitbox: Area2D = get_node("Node2D/Sprite2D/Hitbox")
@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var cool_down_timer: Timer = get_node("CoolDownTimer")

func _ready() -> void:
	if not on_floor:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)

	# Server-seitige Logik wird hier hinzugefügt, Animationen und UI-Funktionen wurden entfernt


func move(mouse_direction: Vector2) -> void:
	if ranged_weapon:
		rotation_degrees = rad_to_deg(mouse_direction.angle()) + rotation_offset
	else:
		rotation = mouse_direction.angle()
		hitbox.knockback_direction = mouse_direction


func _on_PlayerDetector_body_entered(body: PhysicsBody2D) -> void:
	if body != null:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		player_detector.set_collision_mask_value(2, true)


func interpolate_pos(initial_pos: Vector2, final_pos: Vector2) -> void:
	position = initial_pos
	if tween != null:  # Prüfen, ob ein altes Tween vorhanden ist, und es entfernen
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", final_pos, 0.8).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	player_detector.set_collision_mask_value(1, true)


func _on_CoolDownTimer_timeout() -> void:
	can_active_ability = true
