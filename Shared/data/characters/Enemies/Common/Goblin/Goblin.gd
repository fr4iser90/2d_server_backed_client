extends Enemy

const THROWABLE_KNIFE_SCENE: PackedScene = preload("res://Client/Characters/Enemies/Goblin/ThrowableKnife.tscn")

const MAX_DISTANCE_TO_PLAYER: int = 80
const MIN_DISTANCE_TO_PLAYER: int = 40

@export var projectile_speed: int = 150

var can_attack: bool = true
var distance_to_player: float

@onready var attack_timer: Timer = get_node("AttackTimer")
@onready var aim_raycast: RayCast2D = get_node("AimRayCast")

signal attack_performed(position: Vector2, direction: Vector2)

func _on_PathTimer_timeout() -> void:
	if is_instance_valid(player):
		distance_to_player = (player.position - global_position).length()
		if distance_to_player > MAX_DISTANCE_TO_PLAYER:
			_get_path_to_player()
		elif distance_to_player < MIN_DISTANCE_TO_PLAYER:
			_get_path_to_move_away_from_player()
		else:
			aim_raycast.target_position = player.position - global_position
			if can_attack and state_machine.state == state_machine.states.idle and not aim_raycast.is_colliding():
				can_attack = false
				_throw_knife()
				attack_timer.start()
	else:
		mov_direction = Vector2.ZERO

func _get_path_to_move_away_from_player() -> void:
	var dir: Vector2 = (global_position - player.position).normalized()
	navigation_agent.target_position = global_position + dir * 100

func _throw_knife() -> void:
	var direction = (player.position - global_position).normalized()
	var projectile: Area2D = THROWABLE_KNIFE_SCENE.instantiate()
	projectile.launch(global_position, direction, projectile_speed)
	get_tree().current_scene.add_child(projectile)
	emit_signal("attack_performed", global_position, direction)  # Sende Signal bei Angriff

func _on_AttackTimer_timeout() -> void:
	can_attack = true
