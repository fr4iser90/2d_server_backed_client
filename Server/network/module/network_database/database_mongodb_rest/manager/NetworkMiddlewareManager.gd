# res://src/core/network/DatabaseMiddlewareManager.gd (Server)
extends Node

var node_config_manager = null
var backend_routes_manager = null
var route_handlers: Dictionary = {}  # Dictionary to store route-handler mappings
var managers: Dictionary = {}  # Dictionary to store backend managers
var handlers: Dictionary = {}  # Dictionary to store backend handlers

var is_initialized = false  # Prevent double initialization

func initialize():
	if is_initialized:
		return
	is_initialized = true
	GlobalManager.DebugPrint.debug_info("Initializing DatabaseMiddlewareManager...", self)
	_reference_nodes()

# Helper to reference entities (common structure)
func _reference_entities(node_type: String, paths: Dictionary, target: Dictionary):
	for key in paths.keys():
		var node = GlobalManager.NodeManager.get_node_from_config(node_type, key)
		if node:
			target[key] = node
			GlobalManager.DebugPrint.debug_info("Referenced: " + key, self)
		else:
			GlobalManager.DebugPrint.debug_error("Error: Could not reference " + key, self)

func _reference_nodes():
	GlobalManager.DebugPrint.debug_info("Referencing database managers and handlers...", self)
	_reference_entities("backend_manager", GlobalManager.NodeManager.node_map_manager.backend_manager, managers)
	_reference_entities("NetworkGameModuleService", GlobalManager.NodeManager.node_map_manager.network_handler, handlers)

# Register the route handlers with the appropriate routes
func register_route_handlers():
	var all_routes = backend_routes_manager.routes
	for route_path in all_routes.keys():
		var short_name = _get_short_name(route_path)
		if route_handlers.has(short_name):
			GlobalManager.DebugPrint.debug_info("Handler registered for route: " + short_name, self)
		else:
			GlobalManager.DebugPrint.debug_warning("No handler found for route: " + short_name, self)

# This function processes incoming client requests
func handle_client_request(route_name: String, client_data: Dictionary, peer_id: int) -> void:
	GlobalManager.DebugPrint.debug_info("Handling client request for route: " + route_name, self)

	if not backend_routes_manager:
		GlobalManager.DebugPrint.debug_error("Error: DatabaseEndPointManager is not set.", self)
		return

	var route_info = backend_routes_manager.get_route(route_name)
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_error("Error: Route not found for " + route_name, self)
		return

	# Check if there is a handler for the route
	var short_name = _get_short_name(route_name)
	if route_handlers.has(short_name):
		# Call the corresponding handler
		route_handlers[short_name].handle_packet(client_data, peer_id)
	else:
		GlobalManager.DebugPrint.debug_warning("No handler registered for route: " + short_name, self)

# Utility method to get the last part of the path
func _get_short_name(path: String) -> String:
	var parts = path.split("/")
	return parts[parts.size() - 1]
