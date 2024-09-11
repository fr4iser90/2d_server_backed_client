extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	set_state(states.move)

func _state_logic(_delta: float) -> void:
	if state == states.move:
		parent.chase()
		parent.move()

func _get_transition() -> int:
	match state:
		states.idle:
			if parent.distance_to_player > parent.MAX_DISTANCE_TO_PLAYER or parent.distance_to_player < parent.MIN_DISTANCE_TO_PLAYER:
				return states.move
		states.move:
			if parent.distance_to_player < parent.MAX_DISTANCE_TO_PLAYER and parent.distance_to_player > parent.MIN_DISTANCE_TO_PLAYER:
				return states.idle
		states.hurt:
			if not animation_player.is_playing():
				return states.move
	return -1

func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.idle:
			_sync_state_with_clients("idle")
		states.move:
			_sync_state_with_clients("move")
		states.hurt:
			_sync_state_with_clients("hurt")
		states.dead:
			_sync_state_with_clients("dead")

func _sync_state_with_clients(state_name: String) -> void:
	animation_player.play(state_name)
	# Hier kannst du ein Signal senden, um den Zustand des Feindes an die Clients zu synchronisieren
	emit_signal("state_changed", state_name)
