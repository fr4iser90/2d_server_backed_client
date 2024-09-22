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
	print("Initializing NetworkServerBackendManager...")
	_reference_nodes()
	emit_signal("network_server_backend_manager_initialized")
	

func connect_to_backend(ip: String, port: String, token: String):
	print("Connecting to backend...")
	if not nodes_referenced:
		_reference_nodes()
	emit_signal("network_server_backend_connection_established")
	_authenticate_backend()

func _authenticate_backend():
	if is_authenticated:
		print("Backend is already authenticated.")
		return
	print("Authenticating backend...")
	var auth_server_manager = managers.get("auth_server_manager")
	if auth_server_manager:
		auth_server_manager.connect("authentication_complete", Callable(self, "_on_backend_authenticated"))
		auth_server_manager.authenticate_server()
	else:
		print("Error: AuthServerManager not found.")

func _on_backend_authenticated(success: bool):
	if success:
		is_authenticated = true
		print("Backend authentication successful. Fetching routes")
		var backend_routes_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "backend_routes_manager")
		backend_routes_manager.fetch_routes()
		emit_signal("network_server_backend_authentication_success", true)
	else:
		print("Backend authentication failed.")
		is_connected = false
		emit_signal("network_server_backend_authentication_success", false)

# Reference backend managers and handlers
func _reference_nodes():
	print("Referencing backend managers and handlers...")
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "network_meta_manager", managers)
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "backend_manager", managers)
	GlobalManager.NodeManager.reference_map_entry("CoreMap", "network_handler", handlers)
	var nodes_referenced = true
