# InstanceCreationHandler
extends Node

@onready var instance_manager = $"../.."

var instances = {}

func find_or_create_instance(scene_name: String) -> String:
	var max_players = instance_manager.get_max_players_per_instance()
	for key in instances.keys():
		if instances[key]["scene_path"] == scene_name and instances[key]["players"].size() < max_players:
			return key

	return create_instance(scene_name)

func create_instance(scene_name: String) -> String:
	var instance_key = scene_name + ":" + str(instances.size() + 1)
	instances[instance_key] = {
		"scene_path": scene_name,
		"players": [],
		"mobs": [],
		"npcs": []
	}
	print("Instance created with key: ", instance_key)
	return instance_key

func add_player_to_instance(instance_key: String, player_data: Dictionary):
	instances[instance_key]["players"].append(player_data)
