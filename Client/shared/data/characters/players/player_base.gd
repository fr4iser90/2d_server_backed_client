extends Node  # Not CharacterBody2D anymore since no direct movement

# Character stats and other common logic, but no movement here
var character_class = ""
var health = 100
var speed = 100  # Could still keep speed in case it's relevant for calculations

func set_initial_stats(char_class: String):
	character_class = char_class
	print("Initializing player with class: ", character_class)

func apply_damage(amount: int):
	health -= amount
	print("Player health is now: ", health)
