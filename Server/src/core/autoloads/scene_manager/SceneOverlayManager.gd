extends Node

# Adds an overlay scene (e.g., for menus or dialogs)
func overlay_scene(scene_name: String, scene_loader: Node) -> Node:
	var scene_instance = scene_loader.load_scene(scene_name)
	if scene_instance != null:
		get_tree().root.add_child(scene_instance)
		return scene_instance
	else:
		print("Error adding scene overlay.")
		return null

# Removes an overlay scene
func remove_overlay_scene(scene_instance: Node):
	if scene_instance != null:
		scene_instance.queue_free()
	else:
		print("No overlay scene to remove.")
