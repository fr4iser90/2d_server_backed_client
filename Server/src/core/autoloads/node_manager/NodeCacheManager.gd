# res://src/core/autoloads/node_manager/NodeCacheManager.gd
extends Node

var node_config = preload("res://src/core/autoloads/node_manager/NodeConfigManager.gd").new()
var node_cache: Dictionary = {}
var node_flags: Dictionary = {} 


	
# Cache a node if it's marked for caching, otherwise just return it without caching
func cache_node(node_type: String, node_name: String):
	var node_info = node_config.get_node_info(node_type, node_name)
	if not node_info:
		#print("Error: Invalid node name", node_name)
		return
	
	# Only cache the node if caching is allowed
	if not node_cache.has(node_name) and node_info["cache"]:
		var node_path = node_info["path_tree"]
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

func get_node_from_config(node_type: String, node_name: String, auto_initialize := true) -> Node:
	if auto_initialize:
		return init_and_cache_node(node_type, node_name)
	else:
		return get_cached_node(node_type, node_name)
		

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
