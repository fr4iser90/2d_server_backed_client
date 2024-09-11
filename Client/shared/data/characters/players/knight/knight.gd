extends "res://src/core/player_management/player_movement/player_movement.gd"

# Specific properties for the Knight class
var health = 100
var strength = 10
var defense = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Knight character ready with health: ", health)
	
	# Call parent method to initialize any base player setup
	# Custom initialization for Knight class
	apply_knight_special_stats()

func apply_knight_special_stats():
	strength += 5  # Example of class-specific stat boost
	print("Knight's strength after boost: ", strength)
