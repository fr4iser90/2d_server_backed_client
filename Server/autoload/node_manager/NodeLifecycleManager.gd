# res://src/core/autoload/node_manager/NodeLifecycleManager.gd
extends Node

var node_cache_manager = preload("res://autoload/node_manager/NodeCacheManager.gd").new()
var node_state_manager = preload("res://autoload/node_manager/NodeStateManager.gd").new()

# Initialize a node and set it to "ready"
func initialize_node(node_type: String, node_name: String) -> Node:
	GlobalManager.DebugPrint.debug_info("Initializing node: " + node_name + " of type: " + node_type, self)
	var node = node_cache_manager.get_cached_node(node_type, node_name)
	if node == null:
		GlobalManager.DebugPrint.debug_error("Error: Could not find or cache node: " + node_name, self)
		return null

	if not node_state_manager.check_node_ready(node_name):
		if node.has_method("initialize"):
			node.initialize()
			node_state_manager.mark_node_ready(node_name)
			GlobalManager.DebugPrint.debug_info("Node initialized and marked as ready: " + node_name, self)
		else:
			GlobalManager.DebugPrint.debug_warning("Node does not have initialize method: " + node_name, self)
	else:
		GlobalManager.DebugPrint.debug_info("Node is already ready: " + node_name, self)

	return node

# Activate a node (e.g., make it visible and active)
func activate_node(node_name: String):
	if node_state_manager.check_node_ready(node_name):
		var node = node_cache_manager.get_cached_node("", node_name)
		if node:
			node.visible = true  # Example of activation
			GlobalManager.DebugPrint.debug_info("Node activated: " + node_name, self)
		else:
			GlobalManager.DebugPrint.debug_error("Error: Node not found in cache: " + node_name, self)
	else:
		GlobalManager.DebugPrint.debug_warning("Error: Node is not ready for activation: " + node_name, self)

# Deactivate a node (e.g., make it invisible or inactive)
func deactivate_node(node_name: String):
	var node = node_cache_manager.get_cached_node("", node_name)
	if node:
		node.visible = false  # Example of deactivation
		GlobalManager.DebugPrint.debug_info("Node deactivated: " + node_name, self)
	else:
		GlobalManager.DebugPrint.debug_error("Error: Node not found in cache: " + node_name, self)

# Free a node and release its resources, updating state flags
func free_node(node_name: String):
	if node_cache_manager.node_cache.has(node_name):
		var node = node_cache_manager.node_cache[node_name]
		node.queue_free()  # Free the node and its resources
		node_cache_manager.node_cache.erase(node_name)
		node_state_manager.node_flags.erase(node_name)
		GlobalManager.DebugPrint.debug_info("Node freed and removed from cache and state manager: " + node_name, self)
	else:
		GlobalManager.DebugPrint.debug_warning("Error: Node not found in cache for freeing: " + node_name, self)

# Reset node state in the NodeStateManager
func reset_node_state(node_name: String):
	node_state_manager.node_flags.erase(node_name)
	GlobalManager.DebugPrint.debug_info("Node state reset for: " + node_name, self)

# Reference node group
func reference_node_group(node_type: String, paths: Dictionary, target: Dictionary):
	GlobalManager.DebugPrint.debug_info("Referencing node group of type: " + node_type, self)
	for key in paths.keys():
		var node = node_cache_manager.get_node_from_config(node_type, key)
		if node:
			target[key] = node
			GlobalManager.DebugPrint.debug_info("Referenced node: " + key, self)
		else:
			GlobalManager.DebugPrint.debug_error("Error: Could not reference node: " + key, self)
