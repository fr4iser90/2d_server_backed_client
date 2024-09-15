# res://src/core/autoload/node_manager/NodeScanner.gd
extends Node

var node_state_manager = preload("res://src/core/autoload/node_manager/NodeStateManager.gd").new()

# Function to recursively traverse nodes and capture their names, paths, and states
func scan_node_tree(node: Node) -> void:
	# Print the name and path of the current node
	var node_name = node.name
	var node_path = node.get_path()

	# If the node has a script, get the path to the assigned script
	var script_path = ""
	if node.get_script() != null:
		script_path = node.get_script().resource_path
	
	# Print the node information
	print("Node Name: %s, Node Path: %s, Script Path: %s" % [node_name, node_path, script_path])

	# Additional information on the node's state (if available)
	if node_state_manager != null and node_state_manager.check_node_ready(node_name):
		print("%s is ready." % node_name)
	else:
		print("%s is not ready or no state manager assigned." % node_name)

	# Recursively call the function for all child nodes
	for child in node.get_children():
		if child is Node:
			scan_node_tree(child)
