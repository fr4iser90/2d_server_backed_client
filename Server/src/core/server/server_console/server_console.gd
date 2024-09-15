# res://src/core/server/server_console.gd
extends Control

var server_init  
var network_server_backend_manager
var network_server_client_manager
var auto_connect_enabled
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
@onready var player_list = $ServerConsoleContainer/Mid/SideContainer/PlayerContainer/PlayerContainerPanel/PlayerList
@onready var server_client_log = $ServerConsoleContainer/Mid/ConsoleContainer/ServerClientPanel/ServerClientLog
@onready var server_backend_log = $ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanel/ServerBackendLog

var server_console_settings = preload("res://src/core/server/config/server_console_settings.gd").new()
var config_file_path = "res://user/config/console.cfg"

enum BackendStatus {
	DISCONNECTED,
	CONNECTING,
	AUTHENTICATED,
	AUTHENTICATION_FAILED
}


func _ready():
	print("Openened ServerConsole...")
	if has_node("/root/ServerInit"):
		print("Waiting for ServerInit to finish...")
		server_init = get_node("/root/ServerInit")
		server_init.connect("all_managers_initialized", Callable(self, "_on_server_initialized"))
		connect_to_backend_button.connect("pressed", Callable(self, "_on_connect_pressed"))
	else:
		print("Error: ServerInit not found!")
		
	_connect_buttons()
	# Verbinde den Connect-Button mit der Funktion
	
func _connect_buttons():
	# Ensure buttons are connected
	connect_to_backend_button.connect("pressed", Callable(self, "_on_connect_pressed"))
	auto_connect_button.connect("toggled", Callable(self, "_on_auto_connect_toggled"))
	
	# Load settings using the external module
	auto_connect_enabled = server_console_settings.load_settings()	
	if auto_connect_button:
		auto_connect_button.set_pressed(auto_connect_enabled)
		


func _on_auto_connect_toggled(button_pressed: bool):
	if auto_connect_enabled != button_pressed:
		# Save the new state only if it has changed
		server_console_settings.save_settings(button_pressed)
		auto_connect_enabled = button_pressed
	
# Funktion, die aufgerufen wird, wenn der Connect-Button gedrückt wird
func _on_connect_pressed():
	# Set the values in the global config from the UI inputs
	GlobalManager.GlobalConfig.set_backend_ip_dns(backend_ip.text)
	GlobalManager.GlobalConfig.set_backend_port(int(backend_port.text))
	GlobalManager.GlobalConfig.set_server_port(int(server_port.text))
	GlobalManager.GlobalConfig.set_server_validation_key(server_validation_token.text)


	# Now proceed to establish the backend connection using the updated global config values
	connect_to_backend(GlobalManager.GlobalConfig.get_backend_ip_dns(),
					str(GlobalManager.GlobalConfig.get_backend_port()),
					GlobalManager.GlobalConfig.get_server_validation_key())

# Verbindet mit dem Backend
func connect_to_backend(ip: String, port: String, token: String):
	print("Connecting to backend with IP: %s, Port: %s" % [ip, port])
	network_server_backend_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "network_server_backend_manager")
	if network_server_backend_manager:
		network_server_backend_manager.connect_to_backend(ip, port, token)
		network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_backend_authenticated"))

func _on_backend_authenticated(success: bool):
	if success:
		network_server_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "network_server_client_manager")
		print("Backend authenticated successfully. Starting client network manager...")
		if network_server_client_manager:
			network_server_client_manager.start_server_client_network()
			network_server_client_manager.connect("network_server_client_connection_established", Callable(self, "_on_server_client_network_started"))
		else:
			print("ENetNetworkManager failed to start server")
	else:
		print("Backend authentication failed.")
		emit_signal("backend_authenticated", false)


		
# Callback, wenn der Client erfolgreich verbunden ist
func _on_server_client_network_started():
	print("Client network started. Server is fully operational.")
	
# This function will be called when the ServerInit signals that all managers are ready
func _on_server_initialized():
	print("Server initialized. Proceeding to connect server console.")
		# Trigger connection if auto-connect is enabled
	if auto_connect_enabled:
		_on_connect_pressed()
	var channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	var network_server_backend_manager = GlobalManager.NodeManager.get_cached_node("backend_manager", "network_server_backend_manager")
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	GlobalManager.GlobalServerConsolePrint.connect("log_server_console_message", Callable(self, "_on_log_message_server_client"))
	user_session_manager.connect("user_data_changed", Callable(self, "_on_user_data_changed"))
	network_server_backend_manager.connect("network_server_backend_connection_established", Callable(self, "_on_backend_connected"))
	network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_authentication_complete"))
	#GlobalManager.NodeManager.scan_and_register_all_nodes(get_tree().root)
	#GlobalManager.NodeManager.scan_node_tree(get_tree().root)
	channel_manager.register_channel_map()
	if user_session_manager:
		user_session_manager.connect("user_data_changed", Callable(self, "_on_user_data_changed"))
		custom_print("Connected to user manager signal.")
	else:
		custom_print("User manager not found.")

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
	server_client_log.append_text(message + "\n")
	server_client_log.scroll_to_line(server_client_log.get_line_count() - 1)
	print(message)

func _on_log_message_server_backend(message: String):
	server_backend_log.append_text(message + "\n")
	server_backend_log.scroll_to_line(server_backend_log.get_line_count() - 1)
	custom_print(message)

func custom_print(message: String):
	print(message)
	
# Update player data
func _on_user_data_changed(changed_peer_id: int, user_data: Dictionary):
	var user_session_manager = GlobalManager.NodeManager.get_node_from_config("network_meta_manager", "user_session_manager")
	player_list.clear()  # Clear the list before adding new items
	for id in user_session_manager.users_data.keys():
		var user = user_session_manager.users_data[id]
		# Display the main player data in the ItemList (Username, Selected Character, Scene)
		var username = user.get("username", "Unknown")
		var current_scene = user.get("current_scene", "No Scene")
		var selected_character = user.get("selected_character", {})  # Get selected character if exists
		var character_name = selected_character.get("name", "No Character")  # Default to "No Character" if none selected
		var item_text = "Username: %s, Character: %s, Scene: %s" % [username, character_name, current_scene]
		player_list.add_item(item_text)

		# Construct a tooltip with all user data fields
		var tooltip_text = "Username: %s\nPeerID: %s\nUserID: %s\nToken: %s\nLast Scene: %s\nPosition: %s\nOnline: %s" % [
			username,
			str(id), 		
			user.get("user_id", "No ID"),  # Safely get user_id
			user.get("token", "No Token"),  # Safely get token
			user.get("last_scene", "No Last Scene"),  # Safely get last_scene
			str(user.get("position", Vector3())),  # Safely get position
			str(user.get("is_online", false))  # Safely get is_online
		]
		
		# Set the tooltip for the corresponding item in the list
		player_list.set_item_tooltip(player_list.get_item_count() - 1, tooltip_text)

	custom_print("Player list updated with tooltips.")

# Handle backend connection established signal
func _on_backend_connecting():
	_update_backend_status(BackendStatus.CONNECTING)
	
# Handle authentication completion
func _on_authentication_complete(success: bool):
	if success:
		GlobalManager.SceneManager.print_tree_structure()
		var packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
		packet_manager.cache_channel_map()
		_update_backend_status(BackendStatus.AUTHENTICATED)
	else:
		_update_backend_status(BackendStatus.AUTHENTICATION_FAILED)




