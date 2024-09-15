# res://src/core/autoloads/node_manager/NodeStateManager.gd
extends Node

var node_flags: Dictionary = {}

# Scanne und registriere alle Knoten im Baum
func scan_and_register_all_nodes(node: Node):
	if not node_flags.has(node.name):
		node_flags[node.name] = {"is_ready": false}
		print("Registered node:", node.name)
	
	for child in node.get_children():
		if child is Node:
			scan_and_register_all_nodes(child)

# Markiere einen Knoten als bereit
func mark_node_ready(node_name: String):
	if node_flags.has(node_name):
		node_flags[node_name]["is_ready"] = true
		print("Node marked as ready:", node_name)
	else:
		print("Error: No node found for marking as ready:", node_name)

# Markiere alle Knoten als bereit
func mark_all_nodes_ready():
	for node_name in node_flags.keys():
		mark_node_ready(node_name)

# Überprüfe, ob ein Knoten bereit ist
func check_node_ready(node_name: String) -> bool:
	if node_flags.has(node_name):
		return node_flags[node_name]["is_ready"]
	return false

