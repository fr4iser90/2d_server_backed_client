# res://src/core/autoloads/scene_manager/SceneTransitionManager.gd
extends Node

# Variable to track the currently active scene
var current_scene: Node = null
var cached_windows: Dictionary = {}

# Switches the current scene in the scene tree
func switch_scene(scene_name: String, scene_loader: Node, scene_cache_manager: Node, params: Dictionary = {}):
	var new_scene = scene_loader.load_scene(scene_name)
	if new_scene != null:
		if current_scene != null:
			current_scene.queue_free()
		get_tree().root.call_deferred("add_child", new_scene)
		current_scene = new_scene

		if params.size() > 0 and new_scene.has_method("set_scene_params"):
			new_scene.call_deferred("set_scene_params", params)
	else:
		print("Error switching scene.")

# Shows the scene in a separate window
func show_scene_window(scene_instance: Node):
	print("test opening window")

	# Check if the window for the scene is already cached
	if cached_windows.has(scene_instance.name):
		print("Scene window already open:", scene_instance.name)
		return

	# Create a new window to display the scene
	var scene_window = Window.new()
	scene_window.title = scene_instance.name
	scene_window.min_size = Vector2(800, 600)
	scene_window.add_child(scene_instance)

	# Cache the window for future reference
	cached_windows[scene_instance.name] = scene_window

	# Attach the window to the scene tree's root (very important)
	get_tree().root.add_child(scene_window)

	# Show the window at the center of the screen
	scene_window.popup_centered()

	print("Scene window opened:", scene_instance.name)

# Loads the scene in a window (high-level function)
func load_scene_window(scene_name: String, scene_loader: Node, scene_cache_manager: Node):
	# Try to get the scene from the cache first
	var scene_instance = scene_cache_manager.get_cached_scene(scene_name)
	if scene_instance == null:
		# If not cached, load it
		scene_instance = scene_loader.load_scene(scene_name)
		if scene_instance == null:
			print("Error: Could not load scene:", scene_name)
			return

		# Cache the loaded scene for future use
		scene_cache_manager.cache_scene(scene_name, scene_instance)

	# Show the scene in a window
	show_scene_window(scene_instance)

# Removes the scene window (high-level function)
func remove_scene_window(scene_instance: Node):
	# Check if the window is cached
	if cached_windows.has(scene_instance.name):
		var scene_window = cached_windows[scene_instance.name]
		scene_window.queue_free()  # Closes the window and removes the scene
		cached_windows.erase(scene_instance.name)
		print("Scene window removed:", scene_instance.name)
	else:
		print("Error: No window found for scene:", scene_instance.name)
