# res://src/core/autoloads/scene_manager/SceneCacheManager.gd
extends Node


var scene_cache: Dictionary = {}
	
# Caches a scene instance
func cache_scene(scene_name: String, scene_instance: Node):
	scene_cache[scene_name] = scene_instance

# Returns a cached scene if it exists
func get_cached_scene(scene_name: String) -> Node:
	return scene_cache.get(scene_name, null)

# Removes a scene from the cache
func remove_scene_from_cache(scene_name: String):
	scene_cache.erase(scene_name)
