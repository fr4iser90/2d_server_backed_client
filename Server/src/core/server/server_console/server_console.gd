# ServerConsole.gd
extends Control

# TopStartServer
@onready var server_preset_list = $ServerConsoleContainer/TopStartServer/ServerNameList
@onready var server_start_button = $ServerConsoleContainer/TopStartServer/StartServerButton
@onready var server_stop_button = $ServerConsoleContainer/TopStartServer/StopServerButton
@onready var server_port = $ServerConsoleContainer/TopStartServer/ServerPortInput
@onready var server_auto_start_checkbox = $ServerConsoleContainer/TopStartServer/ServerAutoStartCheckbox
# TopBackend
@onready var backend_ip = $ServerConsoleContainer/TopBackend/BackendIPInput
@onready var backend_port = $ServerConsoleContainer/TopBackend/BackendPortInput
@onready var server_validation_token = $ServerConsoleContainer/TopBackend/ServerValidationTokenInput
@onready var connect_to_backend_button = $ServerConsoleContainer/TopBackend/ConnectToBackend
@onready var disconnect_from_backend_button = $ServerConsoleContainer/TopBackend/DisconnectFromBackend
@onready var auto_connect_button = $ServerConsoleContainer/TopBackend/AutoConnectCheckButton
# Mid
@onready var backend_status_label = $ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanelLabel
@onready var player_list_manager = $ServerConsoleContainer/Mid/SideContainer/PlayerContainer/PlayerContainerPanel/PlayerListManager
@onready var server_log = $ServerConsoleContainer/Mid/ConsoleContainer/ServerClientPanel/ServerLog
@onready var server_backend_log = $ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanel/ServerBackendLog

enum BackendStatus {
	DISCONNECTED,
	CONNECTING,
	AUTHENTICATED,
	AUTHENTICATION_FAILED
}

var server_console_settings = preload("res://src/core/server/config/server_console_settings.gd").new()
var config_file_path = "res://user/config/console.cfg"

var server_init  
var auto_connect_enabled

var network_server_backend_manager
var network_server_client_manager
var user_session_manager
var channel_manager
var packet_manager


func _ready():
	if has_node("/root/ServerInit"):
		GlobalManager.DebugPrint.debug_info("Waiting for ServerInit to finish...", self)
		server_init = get_node("/root/ServerInit")
		server_init.connect("all_managers_initialized", Callable(self, "_on_server_initialized"))
		# Ensure buttons are connected
		connect_to_backend_button.connect("pressed", Callable(self, "_on_connect_pressed"))
		auto_connect_button.connect("toggled", Callable(self, "_on_auto_connect_toggled"))
		player_list_manager.initialize()
	else:
		GlobalManager.DebugPrint.debug_error("Error: ServerInit not found!", self)
	_get_manager()
	_prepare()
	
func _get_manager():

	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	network_server_backend_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "network_server_backend_manager")
	network_server_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "network_server_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	
func _prepare():
	# Load settings using the external module
	auto_connect_enabled = server_console_settings.load_settings()	
	if auto_connect_button:
		auto_connect_button.set_pressed(auto_connect_enabled)
	call_deferred("auto_connect")
	
func auto_connect():
	if auto_connect_enabled:
		_on_connect_pressed()

func _on_auto_connect_toggled(button_pressed: bool):
	if auto_connect_enabled != button_pressed:
		# Save the new state only if it has changed
		server_console_settings.save_settings(button_pressed)
		auto_connect_enabled = button_pressed
	
# Function that is called when the connect button is pressed
func _on_connect_pressed():
	_get_manager()
	# Set the values in the global config from the UI inputs
	GlobalManager.GlobalConfig.set_backend_ip_dns(backend_ip.text)
	GlobalManager.GlobalConfig.set_backend_port(int(backend_port.text))
	GlobalManager.GlobalConfig.set_server_port(int(server_port.text))
	GlobalManager.GlobalConfig.set_server_validation_key(server_validation_token.text)
	# Now proceed to establish the backend connection using the updated global config values
	connect_to_backend(GlobalManager.GlobalConfig.get_backend_ip_dns(),
					str(GlobalManager.GlobalConfig.get_backend_port()),
					GlobalManager.GlobalConfig.get_server_validation_key())

# Connect to backend
func connect_to_backend(ip: String, port: String, token: String):
	GlobalManager.DebugPrint.debug_info("Connecting to backend with IP: %s, Port: %s" % [ip, port], self)
	# Ensure this part still runs
	if network_server_backend_manager:
		network_server_backend_manager.connect_to_backend(ip, port, token)
		network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_backend_authenticated"))


func _on_backend_authenticated(success: bool):
	if success:
		GlobalManager.DebugPrint.debug_info("Backend authenticated successfully. Starting client network manager...", self)
		if network_server_client_manager:
			GlobalManager.SceneManager.print_tree_structure()
			network_server_client_manager.connect("network_server_client_network_started", Callable(self, "_on_server_client_network_started"))
			network_server_client_manager.start_server_client_network()
		else:
			GlobalManager.DebugPrint.debug_error("ENetNetworkManager failed to start server", self)
	else:
		GlobalManager.DebugPrint.debug_error("Backend authentication failed.", self)
		emit_signal("backend_authenticated", false)

# Callback when the client network starts
func _on_server_client_network_started():
	GlobalManager.DebugPrint.debug_system("Client network started. Server is fully operational.", self)
	if user_session_manager:
		user_session_manager.connect("user_data_changed", Callable(player_list_manager, "update_player_list"))

# This function will be called when the ServerInit signals that all managers are ready
func _on_server_initialized():
	GlobalManager.DebugPrint.debug_info("Server initialized. Proceeding to connect server console.", self)
	if auto_connect_enabled:
		_on_connect_pressed()
	GlobalManager.GlobalServerConsolePrint.connect("log_server_console_message", Callable(self, "_on_log_message_server_client"))
	user_session_manager.connect("user_data_changed", Callable(self, "_on_user_data_changed"))
	network_server_backend_manager.connect("network_server_backend_connection_established", Callable(self, "_on_backend_connected"))
	network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_authentication_complete"))
	channel_manager.register_channel_map()
	if user_session_manager:
		user_session_manager.connect("user_data_changed", Callable(self, "_on_user_data_changed"))

# Update the status label
func _update_backend_status(status: BackendStatus):
	match status:
		BackendStatus.DISCONNECTED:
			GlobalManager.GlobalServerConsolePrint.print_to_console("Server disconnected from backend.")
			backend_status_label.text = "Backend: Status Disconnected"
		BackendStatus.CONNECTING:
			GlobalManager.GlobalServerConsolePrint.print_to_console("Server connecting to backend.")
			backend_status_label.text = "Backend: Status Connecting..."
		BackendStatus.AUTHENTICATED:
			GlobalManager.GlobalServerConsolePrint.print_to_console("Server authentication in backend completed successfully.")
			backend_status_label.text = "Backend: Status Authenticated"
		BackendStatus.AUTHENTICATION_FAILED:
			GlobalManager.GlobalServerConsolePrint.print_to_console("Server authentication in backend failed.")
			backend_status_label.text = "Backend: Status Authentication Failed"
			
# Handle log messages
func _on_log_message_server_client(message: String):
	if server_log.has_method("log_message"):
		server_log.call("log_message", message)
	else:
		GlobalManager.DebugPrint.debug_error("ServerLog script is missing log_message method", self)

func _on_log_message_server_backend(message: String):
	if server_log.has_method("log_message"):
		server_log.call("log_message", message)
	else:
		GlobalManager.DebugPrint.debug_error("ServerLog script is missing log_message method", self)

# Handle backend connection established signal
func _on_backend_connecting():
	_update_backend_status(BackendStatus.CONNECTING)
	
# Handle authentication completion
func _on_authentication_complete(success: bool):
	if success:
		GlobalManager.SceneManager.print_tree_structure()
		packet_manager.cache_channel_map()
		_update_backend_status(BackendStatus.AUTHENTICATED)
	else:
		_update_backend_status(BackendStatus.AUTHENTICATION_FAILED)
