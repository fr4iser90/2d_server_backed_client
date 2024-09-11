# res://src/core/server/server_init.gd
extends Node

var core_tree
var network_server_client_manager
var network_server_backend_manager
var initialization_complete = false
var server_intialized = false

signal network_server_client_manager_initialized
signal network_server_backend_manager_initialized
signal all_managers_initialized

	
func _ready():
	if GlobalManager:
		GlobalManager.connect("global_manager_ready", Callable(self, "_on_global_manager_ready"))
		#GlobalManager._check_managers_ready()
	else:
		var timer = Timer.new()
		timer.set_wait_time(1.0)
		timer.set_one_shot(true)
		add_child(timer)
		timer.connect("timeout", Callable(self, "_ready"))
		get_node("retry_timer").start()
	

# Diese Funktion wird aufgerufen, wenn GlobalManager signalisiert, dass alle Autoloads geladen sind
func _on_global_manager_ready():
	print("GlobalManager is ready, initializing ServerInit managers...")
	server_intialized = true

	core_tree = GlobalManager.GlobalSceneManager.load_scene("core_tree")
	call_deferred("_starting_networknodes")
	# Lade und initialisiere den Client Manager
	
func _starting_networknodes():
	network_server_client_manager = GlobalManager.GlobalSceneManager.put_scene_at_node("network_server_client_manager", "Core/NetworkManager")
	network_server_backend_manager = GlobalManager.GlobalSceneManager.put_scene_at_node("network_server_backend_manager", "Core/NetworkManager")
	# Warte explizit, bis beide Szenen vollständig geladen und dem Baum hinzugefügt wurden
	call_deferred("_check_initialization")
	
# Diese Methode überprüft wiederholt, ob beide Manager geladen wurden, bevor die Initialisierung abgeschlossen ist.
func _check_initialization():
	if network_server_client_manager and network_server_backend_manager:
		print("Network Server Client Manager and Backend Manager initialized.")
		emit_signal("all_managers_initialized")
		GlobalManager.GlobalServerConsolePrint.connect("log_server_console_message", Callable(self, "_on_log_message_server_client"))
	else:
		print("Waiting for managers to initialize...")
		# Wiederhole die Überprüfung im nächsten Frame
		call_deferred("_check_initialization")

# Diese Funktion wird durch den Connect-Button aufgerufen
func start_backend_connection(ip: String, port: String, token: String):
	print("Starting backend connection with IP: %s, Port: %s" % [ip, port])

	# Stelle die Backend-Verbindung her
	if network_server_backend_manager:
		network_server_backend_manager.connect_to_backend(ip, port, token)
		network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_backend_authenticated"))

# Callback, wenn das Backend erfolgreich verbunden ist
func _on_backend_authenticated(success: bool):
	if success:
		print("Backend connected successfully. Starting client network manager...")
		if network_server_client_manager:
			network_server_client_manager.start_server_client_network()
			network_server_client_manager.connect("network_server_client_connection_established", Callable(self, "_on_server_client_network_started"))
	else:
		print("ENetNetworkManager failed to start server")
		
# Callback, wenn der Client erfolgreich verbunden ist
func _on_server_client_network_started():
	print("Client network started. Server is fully operational.")
