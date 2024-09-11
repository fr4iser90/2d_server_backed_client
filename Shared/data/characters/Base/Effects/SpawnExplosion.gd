extends AnimatedSprite2D

func _ready() -> void:
	play("default")

	# Falls die Explosion auch serverseitig Berechnungen durchführt:
	if is_network_master():
		# Serverseitige Logik wie Schaden an nahegelegene Einheiten
		_apply_damage_to_nearby_units()

func _on_SpawnExplosion_animation_finished() -> void:
	if is_network_master():
		# Falls die Animation beendet ist und das Objekt nur auf dem Server existiert:
		queue_free()

func _apply_damage_to_nearby_units() -> void:
	# Beispiel für serverseitige Berechnung, die nahe Einheiten beschädigt:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(10)  # Beispiel: 10 Schadenspunkte
