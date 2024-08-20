extends Node

var instances = {}
var max_players_per_instance = 20

func create_instance(scene_path: String):
	var instance_id = str(instances.size() + 1)
	var instance_key = scene_path + ":" + instance_id
	instances[instance_key] = {
		"scene_path": scene_path,
		"players": []
	}
	print("Instance created: ", instance_key)
	return instance_key

func assign_player_to_instance(scene_path: String, player):
	# Find an existing instance with available space
	for instance_key in instances.keys():
		if instances[instance_key]["scene_path"] == scene_path and instances[instance_key]["players"].size() < max_players_per_instance:
			instances[instance_key]["players"].append(player)
			print("Player assigned to instance: ", instance_key)
			return instance_key
	
	# If no available instance, create a new one
	var new_instance_key = create_instance(scene_path)
	instances[new_instance_key]["players"].append(player)
	print("Player assigned to new instance: ", new_instance_key)
	return new_instance_key

func remove_player_from_instance(instance_key: String, player):
	if instances.has(instance_key):
		instances[instance_key]["players"].erase(player)
		print("Player removed from instance: ", instance_key)
		
		# Remove the instance if no players remain
		if instances[instance_key]["players"].size() == 0:
			# Notify the SceneManager to unload the scene
			var scene_manager = get_node("/root/SceneManager")
			scene_manager.unload_scene(instances[instance_key]["scene_path"], player)
			
			instances.erase(instance_key)
			print("Instance destroyed: ", instance_key)

func get_instance_for_player(player):
	for instance_key in instances.keys():
		if player in instances[instance_key]["players"]:
			print("Player found in instance: ", instance_key)
			return instance_key
	print("Player not found in any instance")
	return null
