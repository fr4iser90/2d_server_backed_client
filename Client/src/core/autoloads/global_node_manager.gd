extends Node

# Documentation 
# Workflow

# 1. To retrieve a node without initialization:
#     Use get_node_from_config(node_name, false) if you don’t want the node to be initialized.
#     This simply returns a cached node or caches it if needed.

# 2. To retrieve and ensure a node is initialized:
#     Use get_node_from_config(node_name, true) to retrieve and initialize the node if necessary.
#     It ensures the node is ready to use.

# 3. To initialize and cache a node:
#     Call init_and_cache_node(node_name) directly if you want to manually ensure the node is cached and initialized.

# 4. To mark a node as ready:
#     After a node is initialized or loaded, use mark_node_ready(node_name) to signal that it is now ready to use.
#     This is particularly useful in workflows where nodes depend on each other.

# 5. To check if a node is ready:
#     Use check_node_ready(node_name) to verify if a node is ready to use before proceeding with operations that depend on it.

# 6. For temporary nodes:
#     Use use_temporary_node(node) if the node is only needed for a single operation and shouldn’t be cached.
		
var node_config = preload("res://src/core/autoloads/global_node_config.gd").new()
var node_cache: Dictionary = {}
var node_flags: Dictionary = {}  # Tracks initialization and readiness

# This initializes the GlobalNodeManager
func _ready():
	pass

# Cache a node if it's marked for caching, otherwise just return it without caching
func cache_node(node_type: String, node_name: String):
	var node_info = node_config.get_node_info(node_type, node_name)
	if not node_info:
		#print("Error: Invalid node name", node_name)
		return
	
	# Only cache the node if caching is allowed
	if not node_cache.has(node_name) and node_info["cache"]:
		var node_path = node_info["path"]
		var node = get_node_or_null(node_path)
		if node:
			node_cache[node_name] = node
			node_flags[node_name] = {"is_initialized": false, "is_ready": false}
		else:
			print("Error: Could not cache node: ", node_name, " (Path: ", node_path, ")")
	else:
		print("Node already cached or not marked for caching: ", node_name)

# Retrieve a cached node or cache it if allowed; handle temporary nodes
func get_cached_node(node_type: String, node_name: String) -> Node:
	# Check if the node is already cached
	if node_cache.has(node_name):
		return node_cache[node_name]
	
	# Cache the node if it's marked for caching
	cache_node(node_type, node_name)
	
	# Return the node if cached, otherwise null
	return node_cache.get(node_name, null)

# Initialize the node if necessary and cache it
func init_and_cache_node(node_type: String, node_name: String) -> Node:
	var node = get_cached_node(node_type, node_name)
	if node == null:
		print("Error: Could not find or cache node:", node_name)
		return null

	# Automatically initialize if necessary
	if node.has_method("initialize") and not node_flags[node_name]["is_initialized"]:
		node.initialize()
		node_flags[node_name]["is_initialized"] = true
		node_flags[node_name]["is_ready"] = true

	return node

# Retrieve a node from the configuration and initialize if required
func get_node_from_config(node_type: String, node_name: String, auto_initialize := true) -> Node:
	if auto_initialize:
		return init_and_cache_node(node_type, node_name)
	else:
		return get_cached_node(node_type, node_name)

# Mark a node as ready
func mark_node_ready(node_name: String):
	if node_flags.has(node_name):
		node_flags[node_name]["is_ready"] = true
	else:
		print("Error: No node found for marking as ready: ", node_name)

# Check if a node is ready
func check_node_ready(node_name: String) -> bool:
	if node_flags.has(node_name):
		return node_flags[node_name]["is_ready"]
	return false

# Use a temporary node (not cached) for one-time operations
func use_temporary_node(node: Node):
	add_child(node)
	node.queue_free()  # Automatically free the node after use

