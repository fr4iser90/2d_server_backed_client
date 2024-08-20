extends FiniteStateMachine

func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	# Setze den Anfangszustand auf 'idle'
	set_state(states.idle)
	
	
func _state_logic(_delta: float) -> void:
	# Diese Logik wird nur auf dem Server ausgeführt, um Zustände und Bewegungen zu berechnen
	if state == states.idle or state == states.move:
		if parent.is_multiplayer_authority():
			parent.get_input()
			parent.move()
	
	
func _get_transition() -> int:
	# Zustandsübergänge werden ebenfalls nur auf dem Server berechnet
	if parent.is_multiplayer_authority():
		match state:
			states.idle:
				if parent.velocity.length() > 10:
					return states.move
			states.move:
				if parent.velocity.length() < 10:
					return states.idle
			states.hurt:
				if not animation_player.is_playing():
					return states.idle
	return -1
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	# Übergangslogik wird sowohl auf dem Server als auch auf dem Client ausgeführt
	match new_state:
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
			if parent.is_multiplayer_authority():
				parent.cancel_attack()
		states.dead:
			animation_player.play("dead")
			if parent.is_multiplayer_authority():
				parent.cancel_attack()
