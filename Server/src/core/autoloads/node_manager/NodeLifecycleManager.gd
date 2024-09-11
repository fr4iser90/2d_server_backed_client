extends Node

var node_cache_manager = preload("res://src/core/autoloads/node_manager/NodeCacheManager.gd").new()
var node_state_manager = preload("res://src/core/autoloads/node_manager/NodeStateManager.gd").new()

# Initialize a node and set it to "ready"
func initialize_node(node_type: String, node_name: String) -> Node:
	var node = node_cache_manager.get_cached_node(node_type, node_name)
	if node == null:
		print("Error: Could not find or cache node:", node_name)
		return null

	# Check if node is already marked as ready in the state manager
	if not node_state_manager.check_node_ready(node_name):
		if node.has_method("initialize"):
			node.initialize()
			node_state_manager.mark_node_ready(node_name)  # Mark node as ready
		print("Node initialized and marked as ready:", node_name)
	
	return node

# Activate a node (e.g., make it visible and active)
func activate_node(node_name: String):
	if node_state_manager.check_node_ready(node_name):
		var node = node_cache_manager.get_cached_node("", node_name)
		if node:
			node.visible = true  # Example of activation
			print("Node activated:", node_name)
		else:
			print("Error: Node not found in cache:", node_name)
	else:
		print("Error: Node is not ready:", node_name)

# Deactivate a node (e.g., make it invisible or inactive)
func deactivate_node(node_name: String):
	var node = node_cache_manager.get_cached_node("", node_name)
	if node:
		node.visible = false  # Example of deactivation
		print("Node deactivated:", node_name)
	else:
		print("Error: Node not found in cache:", node_name)

# Free a node and release its resources, updating state flags
func free_node(node_name: String):
	if node_cache_manager.node_cache.has(node_name):
		var node = node_cache_manager.node_cache[node_name]
		node.queue_free()  # Free the node and its resources
		
		# Remove from cache and state management
		node_cache_manager.node_cache.erase(node_name)
		node_state_manager.node_flags.erase(node_name)
		
		print("Node freed and removed from cache and state manager:", node_name)
	else:
		print("Error: Node not found in cache:", node_name)

# Reset node state in the NodeStateManager (Optional but useful)
func reset_node_state(node_name: String):
	node_state_manager.node_flags.erase(node_name)
	print("Node state reset for:", node_name)
