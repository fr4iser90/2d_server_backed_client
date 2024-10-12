extends Node

# Managers and Handlers specific to backend-side
var handlers = {}
var managers = {}

signal network_server_backend_manager_initialized
signal network_server_backend_connection_established
signal network_server_backend_authentication_success
signal network_server_backend_login_process_completed

var nodes_referenced = false
var is_initialized = false
var is_connected = false
var is_authenticated = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	GlobalManager.DebugPrint.debug_info("Initializing NetworkServerBackendManager...", self)
	_reference_nodes()
	emit_signal("network_server_backend_manager_initialized")

func connect_to_backend(ip: String, port: String, token: String):
	GlobalManager.DebugPrint.debug_info("Connecting to backend...", self)
	if not nodes_referenced:
		_reference_nodes()
	emit_signal("network_server_backend_connection_established")
	_authenticate_backend()

func _authenticate_backend():
	if is_authenticated:
		GlobalManager.DebugPrint.debug_info("Backend is already authenticated.", self)
		return
	GlobalManager.DebugPrint.debug_info("Authenticating backend...", self)
	var database_server_auth_handler = handlers.get("database_server_auth_handler")
	if database_server_auth_handler:
		database_server_auth_handler.connect("authentication_complete", Callable(self, "_on_backend_authenticated"))
		database_server_auth_handler.authenticate_server()
	else:
		GlobalManager.DebugPrint.debug_error("Error: AuthServerHandler not found.", self)

func _on_backend_authenticated(success: bool):
	if success:
		is_authenticated = true
		GlobalManager.DebugPrint.debug_info("Backend authentication successful. Fetching routes...", self)
		var network_endpoint_manager = managers.get("network_endpoint_manager")
		if network_endpoint_manager:
			network_endpoint_manager.fetch_routes()
		emit_signal("network_server_backend_authentication_success", true)
	else:
		GlobalManager.DebugPrint.debug_error("Backend authentication failed.", self)
		is_connected = false
		emit_signal("network_server_backend_authentication_success", false)

# Reference backend managers and handlers
func _reference_nodes():
	GlobalManager.DebugPrint.debug_info("Referencing backend managers and handlers...", self)
	GlobalManager.NodeManager.reference_map_entry("GlobalNodeMap", "NetworkDatabaseModule", managers)
	GlobalManager.NodeManager.reference_map_entry("GlobalNodeMap", "NetworkDatabaseModuleService", handlers)
	print("NetworkDatabaseMap HANDLER:  ", handlers, "  MANAGER:  ", )
	nodes_referenced = true
