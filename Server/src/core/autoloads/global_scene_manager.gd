# res://src/core/autoloads/global_scene_manager.gd
extends Node

# Loading the scene configuration
var scene_config = preload("res://src/core/autoloads/scene_manager/SceneConfigManager.gd").new()
var node_config = preload("res://src/core/autoloads/node_manager/NodeConfigManager.gd").new()
var current_scene: Node = null


# Scene Manager Variables
var scene_cache_manager = null
var scene_loading_manager = null
var scene_overlay_manager = null
var scene_audio_manager = null
var scene_event_manager = null
var scene_physics_manager = null
var scene_lighting_manager = null
var scene_transition_manager = null
var scene_state_manager = null
var spawn_manager = null
var instance_manager = null

# Flag to track if all scene managers are loaded
var all_scene_managers_loaded = true
signal scene_manager_ready

var scene_manager_name_and_paths = node_config.global_scene_manager

func _ready():
	print(scene_manager_name_and_paths)
	_initialize_scene_managers()

# Initialize and add all Scene Managers as child nodes
func _initialize_scene_managers():
	# Iterate over the managers and add them as children
	for var_name in scene_manager_name_and_paths.keys():
		var manager_info = scene_manager_name_and_paths[var_name]
		var manager_resource = load(manager_info["path_file"])

		# Check if the resource loaded properly and is a Script
		if manager_resource is Script:
			var manager_instance = manager_resource.new()
			manager_instance.name = manager_info["name"]  # Set the custom display name for the node
			add_child(manager_instance)

			# Dynamische Zuweisung zur entsprechenden globalen Variablen
			self.set(var_name, manager_instance)
			print(manager_instance, var_name)
		else:
			print("Error loading scene manager: " + manager_info["path_file"])
			all_scene_managers_loaded = false  # Mark as failed if loading didn't succeed

	# Final check if all managers were loaded successfully
	if all_scene_managers_loaded:
		print("All Scene Managers initialized and added successfully.")
		emit_signal("scene_manager_ready")
	else:
		print("Some Scene Managers failed to load.")

func check_scene_manager_readiness():
	print("check_scene_manager_readiness")
	if all_scene_managers_loaded:
		emit_signal("scene_manager_ready")
		
# Function to get a specific scene manager by name
func get_scene_manager(manager_name: String) -> Node:
	if has_node(manager_name):  # Correct function to check for a child node
		var manager = get_node(manager_name)
		if manager != null:
			print(manager_name + " found.")
			return manager
		else:
			print("Error: " + manager_name + " not found!")
			return null
	else:
		print("Error: " + manager_name + " does not exist!")
		return null

# Function to get all loaded scene managers
func get_all_scene_managers() -> Dictionary:
	var managers = {}
	for var_name in scene_manager_name_and_paths.keys():
		var manager = get_node_or_null(var_name)
		if manager != null:
			managers[var_name] = manager
			print(var_name + " is loaded and available.")
		else:
			print("Error: " + var_name + " not loaded!")
	return managers


func get_scene_path(scene_name: String) -> String:
	return scene_config.get_scene_path(scene_name)
	
# High-Level function to load scenes using SceneLoader
func load_scene(scene_name: String, bool = true):
	scene_loading_manager.load_scene(scene_name, bool)
	
# High-Level function to switch scenes using SceneLoader
func switch_scene(scene_name: String, params: Dictionary = {}):
	scene_loading_manager.switch_scene(scene_name, params)

# High-Level function to get the spawn point from the SceneSpawnManager
func get_spawn_point(scene_instance: Node, spawn_point: String) -> Vector2:
	return spawn_manager.get_spawn_point(scene_instance, spawn_point)
	
# Function to add a scene to a specific node using SceneLoader
func put_scene_at_node(scene_name: String, node_path: String) -> Node:
	return scene_loading_manager.put_scene_at_node(scene_name, node_path)

# Delegate the print tree structure function to SceneStateManager
func print_tree_structure():
	scene_state_manager.print_tree_structure()
	
# High-Level function to add an overlay scene using SceneOverlayManager
func overlay_scene(scene_name: String) -> Node:
	return scene_overlay_manager.overlay_scene(scene_name)

# High-Level function to remove the current scene using SceneLoader
func remove_current_scene():
	scene_loading_manager.remove_current_scene()

# High-Level function to remove an overlay scene using SceneOverlayManager
func remove_overlay_scene(scene_instance: Node):
	scene_overlay_manager.remove_overlay_scene(scene_instance)

# High-Level function to save the current state of the scene using SceneStateManager
func save_current_scene_state() -> Dictionary:
	return scene_state_manager.save_current_scene_state()

# High-Level function to restore the state of a previously saved scene using SceneStateManager
func restore_scene_state(scene_state: Dictionary):
	scene_state_manager.restore_scene_state(scene_state)

# High-Level function to spawn a player in an instance using SpawnManager
func spawn_player_in_instance(player, instance_key: String, spawn_position: Vector2):
	spawn_manager.spawn_player_in_instance(player, instance_key, spawn_position)

# High-Level function to show a scene in a window using SceneTransitionManager
func show_scene_window(scene_instance: Node):
	scene_transition_manager.show_scene_window(scene_instance)
	
func load_scene_window(scene_instance: Node):
	scene_transition_manager.load_scene_window(scene_instance)
	
func remove_scene_window(scene_instance: Node):
	scene_transition_manager.remove_scene_window(scene_instance)
	
# High-Level function to switch scenes with a popup window using SceneLoader
func load_scene_with_popup(scene_name: String, show_popup: bool = false) -> Node:
	return scene_loading_manager.load_scene_with_popup(scene_name, show_popup)

# High-Level function to get a cached scene using SceneCacheManager
func get_cached_scene(scene_name: String) -> Node:
	return scene_cache_manager.get_cached_scene(scene_name)

# High-Level function to cache a scene using SceneCacheManager
func cache_scene(scene_name: String, scene_instance: Node):
	scene_cache_manager.cache_scene(scene_name, scene_instance)

# High-Level function to clear the scene cache using SceneCacheManager
func clear_scene_cache():
	scene_cache_manager.clear_scene_cache()

# High-Level function to trigger events in a scene using SceneEventManager
func trigger_event(event_name: String, params: Dictionary = {}):
	scene_event_manager.trigger_event(event_name, params)

# High-Level function to manage physics in the scene using ScenePhysicsManager
func handle_physics_step(delta: float):
	scene_physics_manager.handle_physics_step(delta)

# High-Level function to manage lighting in the scene using SceneLightingManager
func adjust_lighting(lighting_params: Dictionary):
	scene_lighting_manager.adjust_lighting(lighting_params)

# High-Level function to handle transitions between scenes using SceneTransitionManager
func transition_to_scene(scene_name: String, transition_type: String = "fade"):
	scene_transition_manager.transition_to_scene(scene_name, transition_type)

