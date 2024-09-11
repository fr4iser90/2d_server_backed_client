@icon("res://Art/v1.1 dungeon crawler 16x16 pixel pack/heroes/knight/knight_idle_anim_f0.png")
extends CharacterBody2D
class_name Character

@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready():
	print("Character ready")

# Placeholder functions for later implementation
func move() -> void:
	# Logic to handle movement will be implemented later
	pass

func take_damage(damage: int) -> void:
	# Logic to handle damage will be implemented later
	pass
