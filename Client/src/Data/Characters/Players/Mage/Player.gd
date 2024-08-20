extends Character

const DUST_SCENE: PackedScene = preload("res://Shared/Data/Characters/Player/Knight/Dust.tscn")

@onready var parent: Node2D = get_parent()
@onready var dust_position: Marker2D = get_node("DustPosition")

func _ready() -> void:
	if is_multiplayer_authority():
		_restore_previous_state()

func _restore_previous_state() -> void:
	if is_multiplayer_authority():
		self.hp = SavedData.hp

func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
		if mouse_direction.x > 0 and animated_sprite.flip_h:
			animated_sprite.flip_h = false
		elif mouse_direction.x < 0 and not animated_sprite.flip_h:
			animated_sprite.flip_h = true

func get_input() -> void:
	if is_multiplayer_authority():
		mov_direction = Vector2.ZERO
		if Input.is_action_pressed("ui_down"):
			mov_direction += Vector2.DOWN
		if Input.is_action_pressed("ui_left"):
			mov_direction += Vector2.LEFT
		if Input.is_action_pressed("ui_right"):
			mov_direction += Vector2.RIGHT
		if Input.is_action_pressed("ui_up"):
			mov_direction += Vector2.UP

func spawn_dust() -> void:
	if not is_multiplayer_authority():
		var dust: Sprite2D = DUST_SCENE.instantiate()
		dust.position = dust_position.global_position
		parent.get_child(get_index() - 1).add_sibling(dust)

func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.current = true
	get_node("Camera2D").current = false
