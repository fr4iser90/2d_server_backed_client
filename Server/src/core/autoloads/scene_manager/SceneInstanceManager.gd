# res://src/core/autoloads/scene_manager/SceneInstanceManager.gd
extends Node

var instances: Dictionary = {}
var scene_cache_manager = null
var scene_load_manager = null
var is_initialized = false

func initialize():
	if is_initialized:
		return
	scene_cache_manager = GlobalManager.GlobalNodeManager.get_node_from_config("global_scene_manager", "scene_cache_manager")
	scene_load_manager = GlobalManager.GlobalNodeManager.get_node_from_config("global_scene_manager", "scene_load_manager")
	is_initialized = true
	
# Creates and loads a scene instance
func create_scene_instance(scene_name: String, instance_key: String) -> Node:
	# Try to get the scene from cache
	var scene_instance = scene_cache_manager.get_cached_scene(scene_name)
	
	if scene_instance == null:
		# If not cached, load and instantiate the scene
		var scene_loader = GlobalManager.GlobalNodeManager.get_cached_node("scene_loader")
		scene_instance = scene_loader.load_scene(scene_name, false)
		
		if scene_instance != null:
			# Cache the scene instance
			scene_cache_manager.cache_scene(scene_name, scene_instance)
		else:
			print("Error: Could not load scene", scene_name)
			return null

	instances[instance_key] = scene_instance
	get_tree().root.call_deferred("add_child", scene_instance)
	return scene_instance

# Removes a scene instance by its key
func remove_scene_instance(instance_key: String):
	if instances.has(instance_key):
		var scene_instance = instances[instance_key]
		scene_instance.queue_free()
		instances.erase(instance_key)
		print("Instance removed for key:", instance_key)
