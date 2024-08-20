# src/Core/SceneManagement/SceneData.gd

extends Node

var players = []
var entities = []

func add_player(player):
	if not players.has(player):
		players.append(player)

func remove_player(player):
	if players.has(player):
		players.erase(player)

func add_entity(entity):
	if not entities.has(entity):
		entities.append(entity)

func remove_entity(entity):
	if entities.has(entity):
		entities.erase(entity)

func get_players():
	return players

func get_entities():
	return entities
