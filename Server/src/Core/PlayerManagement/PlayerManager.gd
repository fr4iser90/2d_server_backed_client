extends Node

var players = {}
var scene_manager = null
var instance_manager = null

func init(_scene_manager, _instance_manager):
	scene_manager = _scene_manager
	instance_manager = _instance_manager

func player_connected(player_id, player_data):
	if not players.has(player_id):
		players[player_id] = player_data
		print("Player connected: ", player_id)
		
		var instance_key = instance_manager.assign_player_to_instance(player_data.scene_path, player_data)
		player_data.instance_key = instance_key
		scene_manager.load_scene(player_data.scene_path, player_data)
		player_data.enter_scene(player_data.scene_path, instance_key)
		print("Player ", player_id, " has entered scene: ", player_data.scene_path, " in instance: ", instance_key)

func player_disconnected(player_id):
	if players.has(player_id):
		var player_data = players[player_id]
		scene_manager.player_leave_scene(player_data.scene_path, player_data)
		instance_manager.remove_player_from_instance(player_data.instance_key, player_data)
		players.erase(player_id)
		print("Player disconnected: ", player_id)

func get_player(player_id):
	return players.get(player_id, null)

func update_player_state(player_id, new_state):
	if players.has(player_id):
		players[player_id].update_state(new_state)
		print("Player state updated: ", player_id)
