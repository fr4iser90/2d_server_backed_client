# res://src/core/client/scene/menu/launcher/ConnectionManager.gd (Client)
extends Control

@onready var ip_port_input = $IpPortInput
@onready var connect_button = $ConnectButton
@onready var disconnect_button = $DisconnectButton
@onready var auto_connect_check_box = $AutoConnectCheckBox

var client_server_manager
var data_manager
var user_session_manager

func _ready():
	# Load and set auto-connect settings
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")
	client_server_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	data_manager = get_node("/root/Menu/Launcher/DataManager")
	# Hide the disconnect button initially
	_load_settings()
	disconnect_button.hide()

	# Connect button pressed signal
	connect_button.connect("pressed", Callable(self, "_on_connect_button_pressed"))
	disconnect_button.connect("pressed", Callable(self, "_on_disconnect_button_pressed"))

	# Optionally auto-connect if enabled
	if auto_connect_check_box.is_pressed():
		_on_connect_button_pressed()

	# Handle checkbox toggling
	auto_connect_check_box.connect("toggled", Callable(self, "_on_auto_connect_toggled"))

# Function to load settings and apply them
func _load_settings():
	ip_port_input.text = data_manager.get_last_server_address()
	auto_connect_check_box.set_pressed(data_manager.load_auto_connect())  

# Save the auto-connect setting when toggled
func _on_auto_connect_toggled(pressed: bool):
	data_manager.save_auto_connect(pressed)

# When the connect button is pressed
func _on_connect_button_pressed():
	# Get IP and Port
	var address = ip_port_input.text
	var ip_port = address.split(":")
	var ip = ip_port[0]
	var port = int(ip_port[1])
	GlobalManager.NodeManager.scan_runtime_node_map()
	data_manager.save_last_server_address(ip, port)
	user_session_manager.set_server_ip(ip)
	user_session_manager.set_server_port(port)
	if client_server_manager:
		client_server_manager.connect_to_server()
		connect_button.hide()
		disconnect_button.show()

# When the disconnect button is pressed
func _on_disconnect_button_pressed():
	print("Disconnecting from server...")
	if client_server_manager:
		client_server_manager.disconnect_from_server()
		connect_button.show()
		disconnect_button.hide()
