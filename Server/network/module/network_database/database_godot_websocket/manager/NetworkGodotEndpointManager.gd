# NetworkGodotEndpointManager
extends Node

var route_handlers: Dictionary = {}
var backend_routes_manager: Node = null  # Reference to backend routes

var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	GlobalManager.DebugPrint.debug_info("Initializing WebSocketEndpointManager...", self)
	_reference_nodes()

func _reference_nodes():
	GlobalManager.DebugPrint.debug_info("Referencing backend managers and handlers...", self)
	# Assuming GlobalManager.NodeManager is responsible for managing nodes, use it to reference handlers.

# Handle incoming WebSocket messages
func handle_websocket_message(message: String):
	var json = JSON.new()
	var parsed_message = json.parse(message)

	if parsed_message.error != OK:
		GlobalManager.DebugPrint.debug_error("Failed to parse WebSocket message", self)
		return
	
	var message_data = parsed_message.result
	if message_data.has("route"):
		var route_name = message_data["route"]
		var client_data = message_data.get("data", {})

		GlobalManager.DebugPrint.debug_info("Handling WebSocket message for route: " + route_name, self)
		handle_client_request(route_name, client_data)
	else:
		GlobalManager.DebugPrint.debug_warning("Invalid message format received", self)

func handle_client_request(route_name: String, client_data: Dictionary) -> void:
	GlobalManager.DebugPrint.debug_info("Handling client request for route: " + route_name, self)

	if not backend_routes_manager:
		GlobalManager.DebugPrint.debug_error("Error: BackendRoutesManager is not set.", self)
		return

	var route_info = backend_routes_manager.get_route(route_name)
	if route_info.size() == 0:
		GlobalManager.DebugPrint.debug_error("Error: Route not found for " + route_name, self)
		return

	var short_name = _get_short_name(route_name)
	if route_handlers.has(short_name):
		route_handlers[short_name].handle_packet(client_data)
	else:
		GlobalManager.DebugPrint.debug_warning("No handler registered for route: " + short_name, self)

func _get_short_name(path: String) -> String:
	var parts = path.split("/")
	return parts[parts.size() - 1]
