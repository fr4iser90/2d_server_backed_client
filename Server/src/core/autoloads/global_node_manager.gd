# res://src/core/autoloads/global_scene_manager.gd
extends Node

# Loading the scene configuration
var node_config = preload("res://src/core/autoloads/node_manager/NodeConfigManager.gd").new()

# Scene Manager Variables
var node_config_manager = null
var node_cache_manager = null
var node_state_manager = null
var node_life_cycle_manager = null
var node_retrieval_manager = null
var node_temporary_manager = null
var node_scanner = null

signal node_manager_ready

# Flag to track if all scene managers are loaded
var all_node_managers_loaded = true

var node_manager_name_and_paths = node_config.global_node_manager

func _ready():
	_initialize_scene_managers()

# Initialize and add all Scene Managers as child nodes
func _initialize_scene_managers():
	# Iterate over the managers and add them as children
	for var_name in node_manager_name_and_paths.keys():
		var manager_info = node_manager_name_and_paths[var_name]
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
			print("Error loading node manager: " + manager_info["path_file"])
			all_node_managers_loaded = false  # Mark as failed if loading didn't succeed

	# Final check if all managers were loaded successfully
	if all_node_managers_loaded:
		print("All Node Managers initialized and added successfully.")
		emit_signal("node_manager_ready")
	else:
		print("Some Scene Managers failed to load.")

func check_node_manager_readiness():
	print("check_node_manager_readiness")
	if all_node_managers_loaded:
		emit_signal("node_manager_ready")
		
# Function to get a specific node manager by name
func get_node_manager(manager_name: String) -> Node:
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

# Function to get all loaded node managers
func get_all_node_managers() -> Dictionary:
	var managers = {}
	for var_name in node_manager_name_and_paths.keys():
		var manager = get_node_or_null(var_name)
		if manager != null:
			managers[var_name] = manager
			print(var_name + " is loaded and available.")
		else:
			print("Error: " + var_name + " not loaded!")
	return managers

# NodeCacheManager
func get_node_info(node_type: String, node_name: String) -> Dictionary:
		return node_config_manager.get_node_info(node_type, node_name)
		
func cache_node(node_type: String, node_name: String):
		return node_cache_manager.cache_node(node_type, node_name)
		
func get_cached_node(node_type: String, node_name: String) -> Node:
		return node_cache_manager.get_cached_node(node_type, node_name)
		
func init_and_cache_node(node_type: String, node_name: String) -> Node:
		return node_cache_manager.init_and_cache_node(node_type, node_name)

func get_node_from_config(node_type: String, node_name: String, auto_initialize := true) -> Node:
	return node_cache_manager.get_node_from_config(node_type, node_name, auto_initialize)
		
# NodeStateManager
func mark_node_ready(node_name: String):
		return node_state_manager.mark_node_ready(node_name)
		
func check_node_ready(node_name: String) -> bool:
		return node_state_manager.check_node_ready(node_name)
		
func scan_and_register_all_nodes(node: Node):
		return node_state_manager.scan_and_register_all_nodes(node)

func mark_all_nodes_ready():
		return node_state_manager.mark_all_nodes_ready()
		
# NodeTemporaryNodeManager
func use_temporary_node(node_type: String, node_name: String, auto_initialize := true) -> Node:
		return node_temporary_manager.use_temporary_node(node_type, node_name, auto_initialize)
		
# NodeLifecycleManager
func initialize_node(node_type: String, node_name: String) -> Node:
	return node_life_cycle_manager.initialize_node(node_type, node_name)

func activate_node(node_name: String):
	return node_life_cycle_manager.activate_node(node_name)

func deactivate_node(node_name: String):
	return node_life_cycle_manager.deactivate_node(node_name)

func free_node(node_name: String):
	return node_life_cycle_manager.free_node(node_name)
		
#NodeScanner
func scan_node_tree(node: Node) -> void:
	print(node)
	return node_scanner.scan_node_tree(node)
