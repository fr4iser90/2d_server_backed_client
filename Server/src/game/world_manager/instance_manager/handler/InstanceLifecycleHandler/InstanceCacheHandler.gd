# InstanceCacheHandler
extends Node

var instances = {}  # All instances data
var player_instance_map = {}  # Maps players to instances
var max_players_per_instance = 20

func get_instance_data(instance_key: String) -> Dictionary:
	return instances.get(instance_key, {})

func get_instance_id_for_peer(peer_id: int) -> String:
	return player_instance_map.get(peer_id, "")

func get_available_instance(scene_name: String) -> String:
	for key in instances.keys():
		if instances[key]["scene_path"] == scene_name and instances[key]["players"].size() < max_players_per_instance:
			return key
	return ""

func create_instance(scene_name: String) -> String:
	var instance_key = scene_name + ":" + str(instances.size() + 1)
	instances[instance_key] = {
		"scene_path": scene_name,
		"players": [],
		"mobs": [],
		"npcs": []
	}
	return instance_key

func add_player_to_instance(instance_key: String, player_data: Dictionary):
	instances[instance_key]["players"].append(player_data)
	player_instance_map[player_data["peer_id"]] = instance_key
