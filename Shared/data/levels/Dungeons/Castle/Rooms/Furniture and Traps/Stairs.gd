extends Area2D

@onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")

func _on_Stairs_body_entered(_body: CharacterBody2D) -> void:
	if is_multiplayer_authority():  # Nur auf dem Server ausführen
		collision_shape.set_deferred("disabled", true)
		SceneTransistor.start_transition_to("res://Game.tscn")
		rpc("sync_scene_transition")

@rpc
func sync_scene_transition() -> void:
	# Synchronisiere den Szenenwechsel auf den Clients
	SceneTransistor.start_transition_to("res://Game.tscn")
