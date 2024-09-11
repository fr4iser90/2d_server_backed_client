# res://src/core/autoloads/global_scene_manager.gd
extends Node

# Loading the scene configuration
var scene_config = preload("res://src/core/autoloads/global_scene_config.gd").new()

var current_scene: Node = null
var scene_cache: Dictionary = {}
var node_cache: Dictionary = {}

func _ready():
	pass
	
# Loads and instantiates a scene by name
func load_scene(scene_name: String, add_to_root: bool = true) -> Node:
	var scene_path = scene_config.get_scene_path(scene_name)
	if scene_path == "":
		print("Error: Invalid scene path for", scene_name)
		return null
	
	# Check if the scene is already cached
	if scene_cache.has(scene_name):
		return scene_cache[scene_name]
	
	# Load and instantiate the scene
	var scene = load(scene_path)
	if scene == null:
		print("Error: Could not load scene at path:", scene_path)
		return null
	
	var scene_instance = scene.instantiate()
	if scene_instance == null:
		print("Error: Could not instantiate scene:", scene_name)
		return null
	
	# Add and cache the scene, but only add to root if requested
	if add_to_root:
		get_tree().root.call_deferred("add_child", scene_instance)
	
	scene_cache[scene_name] = scene_instance
	return scene_instance


# Adds a scene to a specific node in the scene tree (creating nodes if necessary)
func put_scene_at_node(scene_name: String, node_path: String) -> Node:
	# Debugging: Szene laden und prüfen
	var scene_instance = load_scene(scene_name, false)  # Load without adding to root
	if scene_instance == null:
		print("Error: Failed to load scene", scene_name)
		return null	
	# Debugging: Sicherstellen, dass der Knoten existiert oder erstellt wird
	var parent_node = get_node_or_create(node_path)
	if parent_node == null:
		print("Error: Could not create or find node path:", node_path)
		return null
	parent_node.add_child(scene_instance)
	for child in parent_node.get_children():
		print(" - ", child.name, " (type: ", child.get_class(), ")")

	# Debugging: Ausgabe der Baumstruktur nach dem Hinzufügen
	return scene_instance


func print_tree_structure():
	print("Printing current tree structure:")
	get_tree().root.print_tree_pretty()
	
# Helper function to get or create a node at the specified path
func get_node_or_create(node_path: String) -> Node:
	# Verwende den Root-Knoten direkt
	var current_node = get_tree().root
	
	# Zerlege den Pfad in einzelne Knoten
	var path_parts = node_path.split("/")
	for part in path_parts:
		if part == "" or current_node == null:
			continue
		# Überprüfen, ob der Knoten bereits existiert
		if current_node.has_node(part):
			current_node = current_node.get_node(part)
		else:
			var new_node = Node.new()
			new_node.name = part
			current_node.add_child(new_node)
			current_node = new_node
	return current_node
		
# Switches the current scene in the scene tree
func switch_scene(scene_name: String, params: Dictionary = {}):
	var new_scene = load_scene(scene_name)
	if new_scene != null:
		if current_scene != null:
			current_scene.queue_free()
		get_tree().root.call_deferred("add_child", new_scene)
		current_scene = new_scene
		# If parameters are passed, call a method in the new scene
		if params.size() > 0 and new_scene.has_method("set_scene_params"):
			new_scene.call_deferred("set_scene_params", params)
	else:
		print("Error switching scene.")

# Adds an overlay scene (e.g., for menus or dialogs)
func overlay_scene(scene_name: String) -> Node:
	var scene_instance = load_scene(scene_name)
	if scene_instance != null:
		get_tree().root.add_child(scene_instance)
		return scene_instance
	else:
		print("Error adding scene overlay.")
		return null

# Removes the current scene
func remove_current_scene():
	if current_scene != null:
		current_scene.queue_free()
		current_scene = null
	else:
		print("No current scene to remove.")

# Removes an overlay scene
func remove_overlay_scene(scene_instance: Node):
	if scene_instance != null:
		scene_instance.queue_free()
	else:
		print("No overlay scene to remove.")

# Saves the current state of the scene
func save_current_scene_state() -> Dictionary:
	if current_scene != null:
		var scene_state = {}
		scene_state["name"] = current_scene.name
		scene_state["path"] = scene_config.get_scene_path(current_scene.name)
		return scene_state
	else:
		print("No current scene to save.")
		return {}

# Restores the state of a previously saved scene
func restore_scene_state(scene_state: Dictionary):
	if scene_state.has("name"):
		switch_scene(scene_state["name"])
	else:
		print("Invalid scene state.")

# Creates and loads a scene instance for the InstanceManager
func create_scene_instance(scene_name: String, instance_key: String) -> Node:
	var scene_path = scene_config.get_scene_path(scene_name)
	if scene_path == "":
		print("Error: Invalid scene path for", scene_name)
		return null

	# Check if an instance with this key already exists in the cache
	if scene_cache.has(instance_key):
		return scene_cache[instance_key]

	# Load and instantiate the scene
	var scene = load(scene_path)
	if scene == null:
		print("Error: Could not load scene at path:", scene_path)
		return null

	var scene_instance = scene.instantiate()
	if scene_instance == null:
		print("Error: Could not instantiate scene:", scene_name)
		return null

	# Add the scene to the root (or any specific node path you want)
	get_tree().root.call_deferred("add_child", scene_instance)

	# Cache the instance under the given key
	scene_cache[instance_key] = scene_instance
	return scene_instance

# Removes a scene instance by its key (e.g., when players leave)
func remove_scene_instance(instance_key: String):
	if scene_cache.has(instance_key):
		var scene_instance = scene_cache[instance_key]
		scene_instance.queue_free()
		scene_cache.erase(instance_key)
		print("Instance removed for key:", instance_key)
	else:
		print("No instance found for key:", instance_key)

func get_spawn_point(scene_name: String, spawn_point: String) -> Vector2:
	var scene_instance = scene_cache.get(scene_name, null)
	
	# If the scene is not in the cache, try to load it and add to cache
	if scene_instance == null:
		print("Scene not cached, attempting to load:", scene_name)
		scene_instance = load_scene(scene_name, false)
		
		if scene_instance == null:
			print("Error: Failed to load or cache scene:", scene_name)
			return Vector2.ZERO
	
	# Check if the scene has a SpawnPoints node
	if scene_instance.has_node("SpawnPoints"):
		var spawn_points = scene_instance.get_node("SpawnPoints")
		
		# Check if the specified spawn point exists under SpawnPoints
		if spawn_points.has_node(spawn_point):
			var spawn_node = spawn_points.get_node(spawn_point)
			print("Spawn point '{}' found at position: ".format(spawn_point), spawn_node.global_position)
			return spawn_node.global_position
		else:
			print("Error: Spawn point '{}' not found in SpawnPoints.".format(spawn_point))
			return Vector2(100, 100)  # Return a default position if spawn point is not found
	else:
		print("Error: No 'SpawnPoints' node found in the scene.")
		return Vector2(100, 100)  # Return a default position if no SpawnPoints node exists


		
# Handles player spawn within the scene for a specific instance
func spawn_player_in_instance(player, instance_key: String, spawn_position: Vector2):
	var instance_manager = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager")
	if scene_cache.has(instance_key):
		var scene_instance = scene_cache[instance_key]
		var player_character = instance_manager.spawn_player_character(player, scene_instance)
		player_character.global_position = spawn_position
		return player_character
	else:
		print("Error: No instance found for key:", instance_key)
		return null

# Utility function to check if running in headless mode (server)
func is_headless() -> bool:
	return OS.has_feature("server")

# Function to create and show a scene in a popup, useful for debug mode
func show_scene_popup(scene_instance: Node):
	var popup = Popup.new()
	popup.rect_min_size = Vector2(600, 400)  # Adjust popup size as needed
	# Set the position of the popup to avoid overlapping with the console
	popup.rect_position = Vector2(300, 300)  # Adjust these values as needed for the popup position
	popup.add_child(scene_instance)  # Add the scene to the popup
	popup.popup()  # Show the popup
	get_tree().root.add_child(popup)  # Add the popup to the root node

func show_scene_window(scene_instance: Node):
	# Create a SubViewport and SubViewportContainer
	var sub_viewport = SubViewport.new()
	sub_viewport.size = Vector2(800, 600)  # Set the size of the viewport
	
	var sub_viewport_container = SubViewportContainer.new()
	sub_viewport_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sub_viewport_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sub_viewport_container.add_child(sub_viewport)  # Add the viewport to the container
	
	# Create a new window for the scene
	var window = Window.new()
	window.set_min_size(Vector2(800, 600))  # Set the minimum size using set_min_size
	window.title = "Instance Viewer"
	window.add_child(sub_viewport_container)  # Add the viewport container to the window
	
	# Add scene instance to the viewport
	sub_viewport.add_child(scene_instance)
	
	# Show the window centered on the screen
	window.popup_centered()
	get_tree().root.add_child(window)  # Add the window to the root node

func load_scene_with_window(scene_name: String) -> Node:
	# Resolve scene path using the config
	var scene_instance = load_scene(scene_name, false)  # Load the scene, don't add to root
	if scene_instance == null:
		print("Error: Could not load scene: ", scene_name)
		return null

	# Show the scene in a separate window
	show_scene_window(scene_instance)

	return scene_instance
	
func load_scene_with_popup(scene_name: String, show_popup: bool = false) -> Node:
	# Resolve scene path using the config
	var scene_path = scene_config.get_scene_path(scene_name)
	if scene_path == "":
		print("Error: Invalid scene path for", scene_name)
		return null

	# Check if the scene is already cached
	if scene_cache.has(scene_name):
		return scene_cache[scene_name]

	# Load and instantiate the scene
	var scene = load(scene_path)
	if scene == null:
		print("Error: Could not load scene at path:", scene_path)
		return null

	var scene_instance = scene.instantiate()
	if scene_instance == null:
		print("Error: Could not instantiate scene:", scene_name)
		return null

	# If not headless, display the scene as a popup (for debugging purposes)
	if !is_headless() and show_popup:
		show_scene_popup(scene_instance)
	else:
		print("Running in headless mode, scene won't be displayed.")

	# Cache the scene
	scene_cache[scene_name] = scene_instance
	return scene_instance
