# res://src/core/autoload/node_manager/NodeScanner.gd

extends Node

# Common Prefixes and Suffixes for Node Naming:

# Prefixes:
# 'service_' - Indicates a service node that handles core game logic or backend logic (e.g., 'service_auth')
# 'module_' - Indicates a module node responsible for controlling or overseeing a system or feature (e.g., 'module_combat', 'module_network')
# 'manager_' - Indicates a manager node responsible for controlling or overseeing a specific system or feature (e.g., 'manager_player')
# 'handler_' - Used for nodes that handle specific tasks or network events, especially in networking scenarios (e.g., 'handler_movement')
# 'controller_' - Indicates a node that handles input or gameplay controls, often tied to player or AI interactions (e.g., 'controller_player')
# 'node_' - Used for general-purpose or utility nodes that don't fit into more specific categories (e.g., 'node_util')
# 'component_' - Marks components that are attached to larger entities (e.g., 'component_health' for health in an entity)

# Suffixes:
# '_service' - Suffix for service nodes that manage specific features or systems (e.g., 'auth_service', 'inventory_service')
# '_module' - Suffix for module nodes, indicating that the node represents a self-contained feature or group (e.g., 'combat_module', 'audio_module')
# '_manager' - Suffix for manager nodes, used to centralize control over a game feature (e.g., 'player_manager', 'network_manager')
# '_handler' - Suffix for nodes that handle specific events, primarily used in networking (e.g., 'movement_handler', 'chat_handler')
# '_controller' - Suffix for nodes that handle input or AI controls (e.g., 'player_controller', 'npc_controller')
# '_state' - Suffix used for nodes that represent a specific state or status in the game (e.g., 'game_state', 'combat_state')
# '_node' - General-purpose suffix for utility nodes that don’t fall under more specific categories (e.g., 'physics_node', 'scene_node')

# Network-specific conventions:
# 'network_' - Prefix for any node related to networking, usually combined with a more specific suffix (e.g., 'network_handler', 'network_manager')
# 'rest_' - Prefix for nodes specific to REST API interactions (e.g., 'rest_auth_handler')
# 'websocket_' - Prefix for nodes handling WebSocket-related functionality (e.g., 'websocket_auth_manager')
# 'enet_' - Prefix for ENet protocol-based networking (e.g., 'enet_server_manager')

# Gameplay-specific conventions:
# 'game_' - Prefix for nodes related to core gameplay features (e.g., 'game_manager', 'game_state')
# 'player_' - Prefix for nodes related to player systems (e.g., 'player_manager', 'player_controller')
# 'combat_' - Prefix for nodes managing combat systems (e.g., 'combat_manager', 'combat_handler')
# 'inventory_' - Prefix for nodes related to inventory systems (e.g., 'inventory_service', 'inventory_manager')
# 'dialog_' - Prefix for dialog systems (e.g., 'dialog_manager', 'dialog_handler')

var node_state_manager = preload("res://autoload/node_manager/NodeStateManager.gd").new()

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
