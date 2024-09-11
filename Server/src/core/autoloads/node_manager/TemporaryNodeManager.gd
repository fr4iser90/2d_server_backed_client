# res://src/core/autoloads/node_manager/TemporaryNodeManager.gd
extends Node

# Use a temporary node (not cached) for one-time operations
func use_temporary_node(node: Node):
	add_child(node)
	node.queue_free()  # Automatically free the node after use
