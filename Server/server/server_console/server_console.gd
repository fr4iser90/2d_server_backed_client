# ServerConsole.gd
extends Control

# TopStartServer
@onready var server_preset_list = $ServerConsoleContainer/TopStartServer/ServerPresetList
@onready var server_start_button = $ServerConsoleContainer/TopStartServer/StartServerButton
@onready var server_stop_button = $ServerConsoleContainer/TopStartServer/StopServerButton
@onready var server_port = $ServerConsoleContainer/TopStartServer/ServerPortInput
@onready var server_auto_start_checkbutton = $ServerConsoleContainer/TopStartServer/ServerAutoStartCheckButton
@onready var current_database_type_label = $ServerConsoleContainer/TopStartServer/CurrentDatabaseTypeLabel
# TopBackend
@onready var backend_ip_input = $ServerConsoleContainer/TopBackend/BackendIPInput
@onready var backend_port_input = $ServerConsoleContainer/TopBackend/BackendPortInput
@onready var server_validation_token = $ServerConsoleContainer/TopBackend/ServerValidationTokenInput
@onready var connect_to_backend_button = $ServerConsoleContainer/TopBackend/ConnectToBackend
@onready var disconnect_from_backend_button = $ServerConsoleContainer/TopBackend/DisconnectFromBackend
# Mid
@onready var backend_status_label = $ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanelLabel
@onready var player_list_manager = $ServerConsoleContainer/Mid/SideContainer/PlayerContainer/PlayerContainerPanel/PlayerListManager
@onready var server_log = $ServerConsoleContainer/Mid/ConsoleContainer/ServerClientPanel/ServerLog
@onready var server_backend_log = $ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanel/ServerBackendLog
# Handler
@onready var server_console_life_cycle_handler = $Handler/ServerConsoleLifeCycleHandler
@onready var server_console_preset_handler = $Handler/ServerConsolePresetHandler
@onready var server_console_settings_handler = $Handler/ServerConsoleSettingsHandler
@onready var server_console_ui_load_handler = $Handler/ServerConsoleUILoadHandler




enum BackendStatus {
	DISCONNECTED,
	CONNECTING,
	AUTHENTICATED,
	AUTHENTICATION_FAILED
}


var config_file_path = "res://user/config/console.cfg"

var server_init

var auto_start_server_enabled
var auto_connect_database_enabled


var network_server_backend_manager
var network_server_client_manager
var user_session_manager
var channel_manager
var packet_manager

# Populate server preset list
func _populate_preset_list():
	server_preset_list.clear()  # Clear the list
	server_preset_list.add_item("GodotDatabaseWebSocket")
	server_preset_list.add_item("MongoDatabaseRestAP")
	server_preset_list.select(0)  # Default selection

func _get_manager():
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	network_server_backend_manager = GlobalManager.NodeManager.get_cached_node("NetworkDatabaseModule", "NetworkServerDatabaseManager")
	network_server_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkServerClientManager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	network_server_backend_manager.connect("network_server_backend_connection_established", Callable(self, "_on_backend_connecting"))
	network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_authentication_complete"))

func _ready():
	connect_to_backend_button.hide()
	disconnect_from_backend_button.hide()
	_populate_preset_list()
	_connect_buttons()
	_load_settings()
	_check_settings()
	
func _connect_buttons():
	server_auto_start_checkbutton.connect("toggled", Callable(self, "_on_server_auto_start_checkbutton_toggled"))
	server_preset_list.connect("item_selected", Callable(self, "_on_preset_selected"))

func _load_settings():
	var settings = server_console_settings_handler.load_settings()

	auto_connect_database_enabled = settings.get("auto_connect_enabled", false)
	auto_start_server_enabled = settings.get("auto_start_server_enabled", false)

	# Set the preset
	if settings.has("selected_preset"):
		server_preset_list.select(settings["selected_preset"])
	else:
		server_preset_list.select(0)  # Default to the first preset

	# Set the auto-start checkbox
	if server_auto_start_checkbutton:
		server_auto_start_checkbutton.set_pressed(auto_start_server_enabled)

	# Load the network settings into the UI inputs
	if settings.has("backend_ip_input"):
		backend_ip_input.text = settings["backend_ip_input"]
	if settings.has("backend_port_input"):
		backend_port_input.text = str(settings["backend_port_input"])
	if settings.has("server_port_input"):
		server_port.text = str(settings["server_port_input"])
		
		
func _check_settings():
		if auto_start_server_enabled:
			_on_start_server_button_pressed()
		var timer = Timer.new()
		timer.wait_time = 1.0
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout

func _on_start_server_button_pressed():
	var selected_items = server_preset_list.get_selected_items()
	if selected_items.size() > 0:
		var selected_preset = selected_items[0]  # Holt den Index des ausgewählten Presets
		var selected_preset_name = server_preset_list.get_item_text(selected_preset)  # Holt den Namen des ausgewählten Presets

		# Überprüfe, ob der ServerInit bereits existiert
		var current_server_init = get_tree().root.get_node_or_null("ServerInit")
		if current_server_init:
			GlobalManager.DebugPrint.debug_system("ServerInit is already running. Skipping initialization.", self)
			return

		GlobalManager.DebugPrint.debug_system("Loading selected preset: " + selected_preset_name, self)
		server_console_preset_handler.load_preset(selected_preset)
	else:
		GlobalManager.DebugPrint.debug_error("No preset selected for server start", self)


# Function that is called when the connect button is pressed
func connect_to_database():
	_get_manager()
	# Set the values in the global config from the UI inputs
	GlobalManager.GlobalConfig.set_backend_ip_dns(backend_ip_input.text)
	GlobalManager.GlobalConfig.set_backend_port(int(backend_port_input.text))
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
	GlobalManager.NodeManager.scan_runtime_node_map()
	#GlobalManager.SceneManager.print_tree_structure()
	if user_session_manager:
		user_session_manager.connect("user_data_changed", Callable(player_list_manager, "update_player_list"))

# This function will be called when the ServerInit signals that all managers are ready
func _on_server_initialized():
	GlobalManager.DebugPrint.debug_info("Server initialized. Proceeding to connect server console.", self)
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
			server_console_ui_load_handler.load_on_discconnected()
		BackendStatus.CONNECTING:
			server_console_ui_load_handler.load_on_connecting()
		BackendStatus.AUTHENTICATED:
			server_console_ui_load_handler.load_on_server_authentication_successful()
		BackendStatus.AUTHENTICATION_FAILED:
			server_console_ui_load_handler.load_on_server_authentication_failed()

			
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
		packet_manager.cache_channel_map()
		_update_backend_status(BackendStatus.AUTHENTICATED)
	else:
		_update_backend_status(BackendStatus.AUTHENTICATION_FAILED)

func _on_server_auto_start_checkbutton_toggled(button_pressed: bool):
	if auto_start_server_enabled != button_pressed:
		auto_start_server_enabled = button_pressed
		server_console_settings_handler.save_auto_start(auto_start_server_enabled)
		# Wenn Auto-Start aktiviert ist, den Server starten
		if auto_start_server_enabled:
			_on_start_server_button_pressed()
			
func _on_preset_selected(index: int):
	server_console_settings_handler.save_preset(index)

func _on_server_port_changed(new_port: String):
	server_console_settings_handler.save_network_settings(backend_ip_input.text, backend_port_input.text.to_int(), new_port.to_int())

func _on_backend_ip_input_text_changed(new_ip: String):
	server_console_settings_handler.save_network_settings(new_ip, backend_port_input.text.to_int(), server_port.text.to_int())

func _on_backend_port_input_text_changed(new_port: String):
	server_console_settings_handler.save_network_settings(backend_ip_input.text, new_port.to_int(), server_port.text.to_int())
	
	
