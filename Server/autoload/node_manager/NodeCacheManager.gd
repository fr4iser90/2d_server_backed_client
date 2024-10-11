# res://src/core/autoload/node_manager/NodeCacheManager.gd
extends Node

var node_map_manager: Node = null
var node_cache: Dictionary = {}
var node_flags: Dictionary = {}

var is_initialized = false  
var is_debug_enabled = false

func initialize():
	if is_initialized:
		GlobalManager.DebugPrint.debug_info("NodeCacheManager already initialized.", self)
		return
		
	
	GlobalManager.DebugPrint.debug_info("Initializing NodeCacheManager.", self)
	is_initialized = true
	
func _ready():
	GlobalManager.DebugPrint.set_script_debug_level("NodeCacheManager", GlobalManager.DebugPrint.DebugLevel.ERROR)
	if not is_initialized:
		initialize()
	node_map_manager = get_node("/root/GlobalManager/NodeManager/NodeMapManager")

# Retrieve a cached node or cache it if necessary
func get_cached_node(node_category: String, node_name: String) -> Node:
	var node_info = node_map_manager.get_node_from_combined_maps(node_category, node_name)
	GlobalManager.DebugPrint.debug_info("Requesting node: " + node_name + " of type: " + node_category, self)
		
	if node_cache.has(node_name):
		GlobalManager.DebugPrint.debug_info("Node found in cache: " + node_name, self)
		return ensure_node_initialized(node_name)

	GlobalManager.DebugPrint.debug_info("Node not in cache, caching: " + node_name, self)
	cache_node(node_category, node_name)
	return ensure_node_initialized(node_name)

func ensure_node_initialized(node_name: String) -> Node:
	if node_cache.has(node_name):
		var node = node_cache[node_name]
		if not node_flags.has(node_name):
			GlobalManager.DebugPrint.debug_warning("Error: Node flags for " + node_name + " not found.", self)
			return node

		if not node_flags[node_name].has("is_initialized"):
			GlobalManager.DebugPrint.debug_warning("Error: Initialization flag for " + node_name + " missing.", self)
			node_flags[node_name]["is_initialized"] = false

		if not node_flags[node_name]["is_initialized"]:
			GlobalManager.DebugPrint.debug_info("Initializing node: " + node_name, self)
			node_flags[node_name]["is_initialized"] = true

			if node.has_method("initialize"):
				node.initialize()
				GlobalManager.DebugPrint.debug_info("Node initialized: " + node_name, self)

		return node
	return null

func cache_node(node_category: String, node_name: String):
	var node_info = node_map_manager.get_combined_map_data(node_name)
	if not node_info:
		GlobalManager.DebugPrint.debug_warning("Error: Invalid node name " + node_name, self)
		return
	
	if not node_cache.has(node_name) and node_info.get("cache", false):
		var node_path = node_info.get("path_tree", "")
		GlobalManager.DebugPrint.debug_info("Node path for caching: " + node_path, self)
		
		var node = get_node_or_null(node_path)
		if node:
			node_cache[node_name] = node
			node_flags[node_name] = {"is_initialized": false}
			GlobalManager.DebugPrint.debug_info("Successfully cached node: " + node_name, self)
		else:
			GlobalManager.DebugPrint.debug_warning("Error: Could not cache node: " + node_name + " (Path: " + node_path + ")", self)
