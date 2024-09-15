# res://src/core/autoload/node_manager/NodeCacheManager.gd
extends Node

var node_map_manager: Node = null
var node_cache: Dictionary = {}
var node_flags: Dictionary = {}

var is_initialized = false  

# Initialize the manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	
# Ready function to initialize
func _ready():
	if not is_initialized:
		initialize()
	node_map_manager = get_node("/root/GlobalManager/NodeManager/NodeMapManager")

# Cache a node if it's marked for caching, otherwise just return it without caching
func cache_node(node_type: String, node_name: String):
	var node_info = node_map_manager.get_combined_map_data(node_name)

	if not node_info:
		#print("Error: Invalid node name ", node_name)
		return
	
	# Only cache the node if it's not cached yet and marked for caching
	if not node_cache.has(node_name) and node_info["cache"]:
		var node_path = node_info["path_tree"]
		var node = get_node_or_null(node_path)
		if node:
			node_cache[node_name] = node
			node_flags[node_name] = {"is_initialized": false}  # Set the initialized flag
		else:
			#print("Error: Could not cache node: ", node_name, " (Path: ", node_path, ")")
			pass

# Retrieve a cached node or cache it if necessary
func get_cached_node(node_type: String, node_name: String) -> Node:
	if node_cache.has(node_name):
		# Ensure the node is initialized before returning it
		return ensure_node_initialized(node_name)

	# Cache the node if it's not already cached
	cache_node(node_type, node_name)

	return ensure_node_initialized(node_name)

# Ensure the node is initialized if it hasn't been yet
func ensure_node_initialized(node_name: String) -> Node:
	if node_cache.has(node_name):
		var node = node_cache[node_name]
		
		if not node_flags[node_name]["is_initialized"]:
			# Only initialize if it's not initialized yet
			if node.has_method("initialize"):
				node.initialize()
				node_flags[node_name]["is_initialized"] = true
				print("Node initialized: ", node_name)
		
		return node
	return null

# Get a node from config, optionally caching it
func get_node_from_config(node_type: String, node_name: String) -> Node:
	return get_cached_node(node_type, node_name)
