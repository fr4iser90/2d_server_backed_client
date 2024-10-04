# res://src/core/autoload/global_node_manager.gd
extends Node

signal node_manager_ready
# Node Manager Variables
var node_manager_map = preload("res://autoload/map/GlobalManagerMap.gd").new()
var node_map_manager = null
var node_categorization_manager = null 
var node_cache_manager = null
var node_state_manager = null
var node_life_cycle_manager = null
var node_retrieval_manager = null
var node_temporary_manager = null
var node_scanner = null

var initialization_in_progress = false  # Prevent recursion
var node_ready = false
# Flag to track if all nodes managers are loaded
var all_node_managers_loaded = true
var node_manager_name_and_paths = {}
var manager_instances = {}

func _ready():
	node_manager_name_and_paths = node_manager_map.node_manager
	if initialization_in_progress:
		print("Initialization already in progress, skipping...")
		return
	
	initialization_in_progress = true

	# Ensure `node_manager_name_and_paths` is initialized only once
	
	if node_manager_name_and_paths.size() > 0:
		_initialize_node_managers()
	else:
		print("Error: Node Manager Map could not be loaded.")
	
	initialization_in_progress = false

# Initialize and add all Node Managers as child nodes
func _initialize_node_managers():
	print("Initializing Node Managers...")
	
	# Iterate over the managers and add them as children
	for var_name in node_manager_name_and_paths.keys():
		var manager_info = node_manager_name_and_paths[var_name]
		var manager_resource = load(manager_info["path_file"])
		
		if manager_resource is Script:
			var manager_instance = manager_resource.new()
			manager_instance.name = manager_info["name"]
			add_child(manager_instance)
			manager_instances[var_name] = manager_instance
			print("Node Manager instance added:", manager_instance, "variable: ", var_name)
			self.set(var_name, manager_instance)
		else:
			print("Error loading node manager: " + manager_info["path_file"])
			all_node_managers_loaded = false  # Mark as failed if loading didn't succeed

	# Final check if all managers were loaded successfully
	if all_node_managers_loaded:
		node_ready = true  # Set ready to true after successful initialization
		emit_signal("node_manager_ready")
	else:
		print("Some Node Managers failed to load.")
		node_ready = false  # Ensure it's false if something went wrong

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

# Überprüfen, ob alle Manager bereit sind
func check_node_manager_readiness():
	if all_node_managers_loaded:
		emit_signal("node_manager_ready")


# Function to get all loaded node managers
func get_all_node_managers() -> Dictionary:
	var managers = {}
	for var_name in node_manager_name_and_paths.keys():
		var manager = get_node_or_null(var_name)
		if manager != null:
			managers[var_name] = manager
		else:
			print("Error: " + var_name + " not loaded!")
	return managers

func categorize_and_save_runtime_node_map():
		return node_categorization_manager.process_and_save_categorized_node_data()
		
# NodeCacheManager
func get_node_info(node_type: String, node_name: String) -> Dictionary:
		return node_map_manager.get_node_info(node_type, node_name)
		
func cache_node(node_type: String, node_name: String):
		return node_cache_manager.cache_node(node_type, node_name)
		
func get_cached_node(node_type: String, node_name: String) -> Node:
		return node_cache_manager.get_cached_node(node_type, node_name)
		
func init_and_cache_node(node_type: String, node_name: String) -> Node:
		return node_cache_manager.init_and_cache_node(node_type, node_name)

func get_node_from_config(node_type: String, node_name: String, auto_initialize := true) -> Node:
	return node_cache_manager.get_node_from_config(node_type, node_name, auto_initialize)

func get_node_info_from_map(map_name: String, node_type: String , node_name: String) -> Node:
	return node_map_manager.get_node_from_map(map_name, node_type, node_name)

func get_node_from_combined_maps(node_type: String, node_name: String) -> Node:
	return node_map_manager.get_node_from_combined_maps(node_type, node_name)
	
func reference_map_entry(map_name: String, node_type: String, target: Dictionary):
	return node_map_manager.reference_map_entry(map_name, node_type, target)
	
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
# res://src/core/autoload/global_node_manager.gd
func activate_node(node_name: String):
	return node_life_cycle_manager.activate_node(node_name)

func deactivate_node(node_name: String):
	return node_life_cycle_manager.deactivate_node(node_name)

func free_node(node_name: String):
	return node_life_cycle_manager.free_node(node_name)
		
func reference_node_group(node_type: String, paths: Dictionary, target: Dictionary):
	return node_life_cycle_manager.reference_node_group(node_type, paths, target)
	
#NodeScanner
func scan_node_tree(node: Node) -> void:
	return node_scanner.scan_node_tree(node)
