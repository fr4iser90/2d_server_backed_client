# res://src/core/network/backend_middleware_manager.gd (Server)
extends Node

var node_config_manager = null
var backend_routes_manager = null
var route_handlers: Dictionary = {}  # Dictionary to store route-handler mappings
var managers: Dictionary = {}  # Dictionary to store backend managers
var handlers: Dictionary = {}  # Dictionary to store backend handlers

var is_initialized = false  # Doppelinitialisierung verhindern

func initialize():
	if is_initialized:
		return
	is_initialized = true
	_reference_nodes()
	
# Helper to reference entities (common structure)
func _reference_entities(node_type: String, paths: Dictionary, target: Dictionary):
	for key in paths.keys():
		var node = GlobalManager.NodeManager.get_node_from_config(node_type, key)
		if node:
			target[key] = node
			print("Referenced: " + key)
		else:
			print("Error: Could not reference " + key)
			
func _reference_nodes():
	print("Referencing backend managers and handlers...")
	#node_config_manager = GlobalManager.GlobalNodeManager.get_cached_node("global_node_manager", "node_config_manager")
	_reference_entities("backend_manager", GlobalManager.NodeManager.node_map_manager.backend_manager, managers)
	_reference_entities("network_handler", GlobalManager.NodeManager.node_map_manager.network_handler, handlers)
			
func register_route_handlers():
	# Verknüpfe die Route mit den entsprechenden Handlers
	var all_routes = backend_routes_manager.routes
	for route_path in all_routes.keys():
		var short_name = _get_short_name(route_path)
		if route_handlers.has(short_name):
			print("Handler registered for route: ", short_name)
		else:
			print("No handler found for route: ", short_name)

# Diese Funktion verarbeitet die eingehenden Client-Anfragen
func handle_client_request(route_name: String, client_data: Dictionary, peer_id: int) -> void:
	print("Handling client request for route: ", route_name)
	
	if not backend_routes_manager:
		print("Error: BackendRoutesManager is not set.")
		return

	var route_info = backend_routes_manager.get_route(route_name)
	if route_info.size() == 0:
		print("Error: Route not found for ", route_name)
		return
	
	# Prüfe, ob ein Handler für die Route existiert
	var short_name = _get_short_name(route_name)
	if route_handlers.has(short_name):
		# Aufruf des entsprechenden Handlers
		route_handlers[short_name].handle_packet(client_data, peer_id)
	else:
		print("No handler registered for route: ", short_name)

# Utility method to get the last part of the path
func _get_short_name(path: String) -> String:
	var parts = path.split("/")
	return parts[parts.size() - 1]
