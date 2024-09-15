extends Node

# Prefixes and Suffixes Definitions
const PREFIXES = ["service_", "module_", "manager_", "handler_", "controller_", "node_"]
const SUFFIXES = ["_service", "_manager", "_handler", "_controller", "_state", "_node"]

# Reference to node state manager for tracking readiness
var node_state_manager = preload("res://src/core/autoload/node_manager/NodeStateManager.gd").new()

var dynamic_map = {}  # The dynamic map we'll generate

# Function to recursively scan nodes in the scene tree
func scan_node_tree(node: Node) -> void:
	for child in node.get_children():
		if child is Node:
			var node_name = child.name.to_lower()
			var category = _identify_node_category(node_name)
			if category != "":
				_add_to_map(category, node_name, child)
			# Continue scanning child nodes
			scan_node_tree(child)

# Identify if the node is a manager, handler, etc. based on its name
func _identify_node_category(node_name: String) -> String:
	for prefix in PREFIXES:
		if node_name.begins_with(prefix):
			return prefix.replace("_", "") + "_map"
	for suffix in SUFFIXES:
		if node_name.ends_with(suffix):
			return suffix.replace("_", "") + "_map"
	return ""

# Add the identified node to the corresponding map category
func _add_to_map(category: String, node_name: String, node: Node) -> void:
	if not dynamic_map.has(category):
		dynamic_map[category] = {}
	dynamic_map[category][node_name] = {"path_tree": node.get_path()}

# After scanning, print out the dynamic map
func print_dynamic_map():
	print("Generated Dynamic Map:")
	for category in dynamic_map.keys():
		print(category, ":", dynamic_map[category])

func _ready():
	print("Starting node scan...")
	scan_node_tree(get_tree().root)  # Start scanning from the root node
	print_dynamic_map()  # Print the generated map after scanning
