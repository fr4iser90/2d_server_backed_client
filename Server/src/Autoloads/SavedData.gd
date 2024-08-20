extends Node

var players_data: Dictionary = {}

func reset_data(player_id: String) -> void:
	players_data[player_id] = {
		"num_floor": 0,
		"hp": 4,
		"weapons": [],
		"equipped_weapon_index": 0
	}

func get_player_data(player_id: String) -> Dictionary:
	if player_id in players_data:
		return players_data[player_id]
	else:
		reset_data(player_id)
		return players_data[player_id]

func update_player_data(player_id: String, data: Dictionary) -> void:
	players_data[player_id] = data
