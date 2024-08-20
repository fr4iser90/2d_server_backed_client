# src/Core/PlayerManagement/PlayerData.gd

extends Node

var player_id
var position = Vector2()
var inventory = []
var health = 100
var scene_path = ""
var instance_key = ""

func _init(_player_id, _scene_path):
	player_id = _player_id
	scene_path = _scene_path

func update_state(new_state):
	# Update player state with new data
	position = new_state.position if new_state.has("position") else position
	inventory = new_state.inventory if new_state.has("inventory") else inventory
	health = new_state.health if new_state.has("health") else health

func enter_scene(new_scene_path, new_instance_key):
	scene_path = new_scene_path
	instance_key = new_instance_key
	print("Player ", player_id, " entered scene: ", scene_path, " in instance: ", instance_key)
