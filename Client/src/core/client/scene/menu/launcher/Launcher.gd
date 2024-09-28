# res://src/core/client/scene/menu/launcher/Launcher.gd (Client)
extends Control

# Container nodes
@onready var container = $Container
@onready var top = $Container/Top
@onready var top_mid = $Container/TopMid
@onready var mid = $Container/Mid
@onready var bottom = $Container/Bottom

@onready var top_container = $Container/Top
@onready var label = $Container/Top/Label
@onready var status_label = $Container/Top/StatusLabel

# MidTop Elements
@onready var connection_container =	$Container/TopMid/ConnectionContainer
@onready var ip_port_input = $Container/TopMid/ConnectionContainer/IpPortInput
@onready var connect_button = $Container/TopMid/ConnectionContainer/ConnectButton
@onready var disconnect_button = $Container/TopMid/ConnectionContainer/DisconnectButton
@onready var auto_connect_check_box = $Container/TopMid/ConnectionContainer/AutoConnectCheckBox


# User Session Elements 
@onready var user_session_container = $Container/Mid/UserSessionContainer
@onready var login_container = $Container/Mid/UserSessionContainer/Panel/LoginContainer
@onready var username_input = $Container/Mid/UserSessionContainer/Panel/LoginContainer/UsernameInput
@onready var password_input = $Container/Mid/UserSessionContainer/Panel/LoginContainer/PasswordInput

@onready var login_button = $Container/Mid/UserSessionContainer/Panel/LoginContainer/LoginButton
@onready var cancel_button = $Container/Mid/UserSessionContainer/Panel/LoginContainer/CancelButton
@onready var auto_login_check_box = $Container/Mid/UserSessionContainer/Panel/LoginContainer/AutoLoginCheckBox


# Player Character Elements 
@onready var character_container = $Container/Mid/UserSessionContainer/Panel/CharacterContainer
@onready var mage_button = $Container/Mid/UserSessionContainer/Panel/CharacterContainer/MageButton
@onready var archer_button = $Container/Mid/UserSessionContainer/Panel/CharacterContainer/ArcherButton
@onready var knight_button = $Container/Mid/UserSessionContainer/Panel/CharacterContainer/KnightButton
@onready var logout_button = $Container/Mid/UserSessionContainer/Panel/CharacterContainer/LogoutButton

@onready var ui_manager = $UIManager
@onready var data_manager = $DataManager

var initial_auto_connect_state: bool
var initial_auto_login_state: bool

var core_connection_handler
var handle_backend_login

# Disabling login container at the start
func _ready():
	character_container.hide()
	ui_manager.set_login_container_ui_enabled(login_container, false)
	# Load saved preferences
	auto_connect_check_box.set_pressed(data_manager.load_auto_connect())
	auto_login_check_box.set_pressed(data_manager.load_auto_login())

	# Connect signals for toggling states
	auto_connect_check_box.connect("toggled", Callable(self, "_on_auto_connect_toggled"))
	auto_login_check_box.connect("toggled", Callable(self, "_on_auto_login_toggled"))
	_connect_signals()

func _connect_signals():
	core_connection_handler = GlobalManager.NodeManager.get_cached_node("network_handler", "core_connection_handler")
	if core_connection_handler:
		core_connection_handler.connect("connection_established", Callable(self, "_on_connection_established"))
		core_connection_handler.connect("connection_failed", Callable(self, "_on_connection_failed_with_reason"))
		
	handle_backend_login = GlobalManager.NodeManager.get_cached_node("network_handler", "auth_login_handler")
	if handle_backend_login:
		handle_backend_login.connect("login_success", Callable(self, "_on_user_logged_in_successfully"))
		handle_backend_login.connect("login_failed", Callable(self, "_on_login_failed"))


func _disable_login_input(is_disabled: bool):
	if is_disabled:
		login_container.modulate = Color(0.5, 0.5, 0.5, 1)  # Gray out the container
		username_input.editable = false  # Disable text input
		password_input.editable = false
		login_button.disabled = true  # Disable login button
		cancel_button.disabled = true  # Disable back button
	else:
		login_container.modulate = Color(1, 1, 1, 1)  # Reset color to normal
		username_input.editable = true  # Enable text input
		password_input.editable = true
		login_button.disabled = false  # Enable login button
		cancel_button.disabled = false  # Enable back button

# This would be called when the server connection is established
func _on_connection_established():
	#_disable_login_input(false) 
	ui_manager.set_login_container_ui_enabled(login_container, true)
	ui_manager.set_connection_container_ui_enabled(connection_container, false)
	
# Show PlayerContainer after login
func _on_user_logged_in_successfully(session_token: String):
	print("hide login")
	login_container.hide()
	character_container.show()
	character_container.fetch_characters()

