extends Node2D  # Server-seitige Verwaltung der Spielwelt

# Deklaration der benötigten Variablen
var max_hp: int = 10  # Beispielhafter Wert, initialisiere nach Bedarf
var hp: int = 10

var player: Node2D  # Referenz auf den Spieler, falls benötigt

# Eventuell benötigte Server-Funktionen
signal slime_spawned(slime_position: Vector2, slime_scale: Vector2, slime_hp: float)

func _ready() -> void:
	# Logik, die beim Start des Servers ausgeführt wird
	pass

func _process(_delta: float) -> void:
	# Logik, die kontinuierlich auf dem Server ausgeführt wird
	if is_instance_valid(player):
		if player.global_position.y > global_position.y:
			z_index = 0
		else:
			z_index = 1

func duplicate_slime() -> void:
	# Hier wird der Slime geteilt
	if scale > Vector2(1, 1):
		var impulse_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
		_spawn_slime(impulse_direction)
		_spawn_slime(impulse_direction * -1)

func _spawn_slime(direction: Vector2) -> void:
	# Hier wird ein neuer Slime auf dem Server erstellt
	var slime_scene = load("res://Characters/Enemies/Bosses/SlimeBoss.tscn")
	if slime_scene:
		var slime: CharacterBody2D = slime_scene.instantiate()
		slime.position = position
		slime.scale = scale / 2
		slime.hp = max_hp / 2.0
		slime.max_hp = max_hp / 2.0
		get_parent().add_child(slime)
		slime.velocity += direction * 150
		
		# Signal senden, um den Client zu benachrichtigen, dass ein neuer Slime gespawnt wurde
		emit_signal("slime_spawned", slime.position, slime.scale, slime.hp)

# Zusätzliche Funktionen für den Server
