extends Node

func get_scene_path(instance_key: String) -> String:
	if instance_key in instance_scene_map:
		return instance_scene_map[instance_key]
	else:
		print("Scene not found for instance_key: ", instance_key)
		return ""

func load_scene(scene_name: String):
	var scene_path = get_scene_path(scene_name)
	var scene = load(scene_path)
	if scene and scene is PackedScene:
		scene.instantiate()
		print("Scene loaded: ", scene_name)
	else:
		print("Error loading scene: ", scene_name)
