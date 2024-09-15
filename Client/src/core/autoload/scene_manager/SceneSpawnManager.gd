# res://src/core/autoloads/scene_manager/SceneSpawnManager.gd
extends Node

# Get the spawn point from a scene
func get_spawn_point(scene_instance: Node, spawn_point: String) -> Vector2:
	if scene_instance.has_node(spawn_point):
		var spawn_node = scene_instance.get_node(spawn_point)
		return spawn_node.global_position
	else:
		print("Error: Spawn point not found in the scene.")
		# Return a default position if spawn point is not found
		return Vector2(100, 100)

