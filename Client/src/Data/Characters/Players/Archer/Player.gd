extends Character

const DUST_SCENE: PackedScene = preload("res://src/Data/Characters/Player/Knight/Dust.tscn")

@onready var parent: Node2D = get_parent()
@onready var dust_position: Marker2D = get_node("DustPosition")

func _ready() -> void:
	if is_multiplayer_authority():
		_restore_previous_state()
	else:
		# Setup client-side initialization, e.g., camera or other visuals
		switch_camera()

func _restore_previous_state() -> void:
	if is_multiplayer_authority():
		self.hp = SavedData.hp

func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		# Server processes movement and other game logic
		var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
		_update_sprite_direction(mouse_direction)
	else:
		# Client handles local updates for immediate feedback, but actual movement is synced from server
		_update_visuals()

func _update_sprite_direction(mouse_direction: Vector2) -> void:
	if mouse_direction.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
	elif mouse_direction.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true

func _update_visuals() -> void:
	# Any client-only visual updates like effects, HUD updates, etc.
	pass

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
	# Dust effect could be client-side unless you need it synced across all clients
	if not is_multiplayer_authority():
		var dust: Sprite2D = DUST_SCENE.instantiate()
		dust.position = dust_position.global_position
		parent.get_child(get_index() - 1).add_sibling(dust)

func switch_camera() -> void:
	var main_scene_camera: Camera2D = get_parent().get_node("Camera2D")
	main_scene_camera.position = position
	main_scene_camera.current = true
	get_node("Camera2D").current = false
