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

# Retrieve a cached node or cache it if necessary
func get_cached_node(node_type: String, node_name: String) -> Node:
	# Try to get the node info from the combined maps
	var node_info = node_map_manager.get_node_from_combined_maps(node_type, node_name)
		
	# If the node is already cached, ensure it's initialized and return it
	if node_cache.has(node_name):
		return ensure_node_initialized(node_name)

	# If the node is valid, proceed to cache it
	cache_node(node_type, node_name)

	# Ensure the node is initialized and return it
	return ensure_node_initialized(node_name)

# Ensure the node is initialized if it hasn't been yet
func ensure_node_initialized(node_name: String) -> Node:
	if node_cache.has(node_name):
		var node = node_cache[node_name]
		
		if not node_flags.has(node_name):
			print("Error: Node flags for", node_name, "not found")
			return node  # Return it anyway for now, even without flags

		if not node_flags[node_name].has("is_initialized"):
			print("Error: Initialization flag for", node_name, "missing")
			return node  # Return it anyway for now
		
		if not node_flags[node_name]["is_initialized"]:
			# Only initialize if it's not initialized yet
			if node.has_method("initialize"):
				node.initialize()
				node_flags[node_name]["is_initialized"] = true
				#print("Node initialized: ", node_name)
		
		return node
	return null

# Cache a node based on its node_type and node_name
func cache_node(node_type: String, node_name: String):
	#print("Attempting to cache node: ", node_name, " of type: ", node_type)
	
	var node_info = node_map_manager.get_combined_map_data(node_name)
	if not node_info:
		#print("Error: Invalid node name ", node_name)
		return
	
	# Only cache the node if it's not cached yet and marked for caching
	if not node_cache.has(node_name) and node_info.get("cache", false):
		var node_path = node_info.get("path_tree", "")
		#print("Node path for caching: ", node_path)
		
		var node = get_node_or_null(node_path)
		if node:
			node_cache[node_name] = node
			node_flags[node_name] = {"is_initialized": false}  # Set the initialized flag
			#print("Successfully cached node: ", node_name)
		else:
			#print("Error: Could not cache node: ", node_name, " (Path: ", node_path, ")")
			return
	else:
		#print("Node is already cached or not marked for caching: ", node_name)
		return


# Get a node from config, optionally caching it
func get_node_from_config(node_type: String, node_name: String) -> Node:
	return get_cached_node(node_type, node_name)
