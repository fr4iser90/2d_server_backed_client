extends Node

var active_scenes = {}

func load_scene(scene_path: String, player):
	var instance_manager = get_node("/root/InstanceManager")
	var instance_key = instance_manager.assign_player_to_instance(scene_path, player)

	# Ensure the scene is loaded for the instance
	if not active_scenes.has(instance_key):
		# Load the scene for this instance
		var scene = load(scene_path).instantiate()
		add_child(scene)
		active_scenes[instance_key] = {
			"scene": scene,
			"players": [player]
		}
		print("Scene loaded for instance: ", instance_key)
	else:
		# Add player to the existing scene
		active_scenes[instance_key]["players"].append(player)
		print("Player added to scene in instance: ", instance_key)
	
	# Notify the player of the scene load
	player.enter_scene(scene_path)

func unload_scene(scene_path: String, player):
	var instance_manager = get_node("/root/InstanceManager")
	var instance_key = instance_manager.get_instance_for_player(player)
	
	if instance_key and active_scenes.has(instance_key):
		# Remove player from the scene in this instance
		active_scenes[instance_key]["players"].erase(player)
		print("Player left scene in instance: ", instance_key)
		
		# Unload the scene if no players remain
		if active_scenes[instance_key]["players"].size() == 0:
			active_scenes[instance_key]["scene"].queue_free()
			active_scenes.erase(instance_key)
			print("Scene unloaded for instance: ", instance_key)
