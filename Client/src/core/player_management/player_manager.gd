# src/core/player_manager.gd
extends Node

var current_player: Dictionary

func set_player_data(player_data: Dictionary):
	current_player = player_data

func update_player_position(new_position: Vector2):
	if current_player:
		current_player["position"] = new_position

func get_player_position() -> Vector2:
	if current_player:
		return current_player["position"]
	return Vector2.ZERO


