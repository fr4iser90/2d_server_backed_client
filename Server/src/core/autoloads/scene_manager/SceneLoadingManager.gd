# res://src/core/autoloads/scene_manager/SceneLoadManager.gd
extends Node

var scene_config = preload("res://src/core/autoloads/scene_manager/SceneConfigManager.gd").new()
var node_config = preload("res://src/core/autoloads/node_manager/NodeConfigManager.gd").new()
var scene_cache_manager = null

var is_initialized = false

var high_level = true

func _ready():
	initialize()
	
func initialize():
	if is_initialized:
		return
	is_initialized = true

	
# Loads and instantiates a scene by name
func load_scene(scene_name: String, add_to_root: bool = true) -> Node:
	var high_level = true
	# First, try to get the scene from cache
	print("Attempting to retrieve scene_cache_manager from SceneLoadingManager")
	scene_cache_manager = GlobalManager.GlobalNodeManager.get_node_from_config("global_scene_manager", "scene_cache_manager")
	
	if scene_cache_manager == null:
		print("Error: scene_cache_manager is null")
		return null
	
	print("Cache Manager found, attempting to get cached scene")
	var cached_scene = scene_cache_manager.get_cached_scene(scene_name)
	if cached_scene:
		if add_to_root:
			get_tree().root.call_deferred("add_child", cached_scene.duplicate())
		return cached_scene.duplicate()

	var scene_path = scene_config.get_scene_path(scene_name)
	if scene_path == "":
		print("Error: Invalid scene path for", scene_name)
		return null
	
	var scene = load(scene_path)
	if scene == null:
		print("Error: Could not load scene at path:", scene_path)
		return null
	
	var scene_instance = scene.instantiate()
	if scene_instance == null:
		print("Error: Could not instantiate scene:", scene_name)
		return null

	if add_to_root:
		get_tree().root.call_deferred("add_child", scene_instance)
	
	# Cache the loaded scene
	scene_cache_manager.cache_scene(scene_name, scene_instance)
	return scene_instance


# Function to add a scene to a specific node in the scene tree
func put_scene_at_node(scene_name: String, node_path: String) -> Node:
	var high_level = true
	var scene_instance = load_scene(scene_name, false)  # Load scene without adding to root
	if scene_instance == null:
		print("Error: Failed to load scene:", scene_name)
		return null
	
	# Find or create the node where the scene will be added
	var parent_node = get_node_or_create(node_path)
	if parent_node == null:
		print("Error: Could not find or create node:", node_path)
		return null
	
	parent_node.add_child(scene_instance)
	print("Scene added to node:", node_path)
	return scene_instance

# Helper function to get or create a node by its path
func get_node_or_create(node_path: String) -> Node:
	var current_node = get_tree().root
	var path_parts = node_path.split("/")
	
	for part in path_parts:
		if part == "":
			continue
		if current_node.has_node(part):
			current_node = current_node.get_node(part)
		else:
			var new_node = Node.new()
			new_node.name = part
			current_node.add_child(new_node)
			current_node = new_node
	
	return current_node
