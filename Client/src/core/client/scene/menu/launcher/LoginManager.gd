# res://src/core/client/scene/menu/launcher/LoginManager.gd
extends Control

@onready var username_input = $UsernameInput
@onready var password_input = $PasswordInput
@onready var login_button = $LoginButton
@onready var cancel_button = $CancelButton
@onready var status_label = $StatusLabel
@onready var auto_login_check_box = $AutoLoginCheckBox

var handle_backend_login = null

# Initializing variables and connections
func _ready():
	# Set default inputs and connect signals
	_set_default_inputs()
	_connect_signals()

# Set default values for username and password inputs if they are empty
func _set_default_inputs():
	username_input.text = username_input.text if username_input.text != "" else "test"
	password_input.text = password_input.text if password_input.text != "" else "test"

# Connect button signals
func _connect_signals():
	login_button.connect("pressed", Callable(self, "_on_login_button_pressed"))
	cancel_button.connect("pressed", Callable(self, "_on_cancel_button_pressed"))

# Called when the login button is pressed
func _on_login_button_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()

	if username == "" or password == "":
		_set_status_message("Please enter both username and password", Color.RED)
		return

	# Request login if the backend login handler is available
	handle_backend_login = GlobalManager.NodeManager.get_cached_node("network_handler", "auth_login_handler")

	if handle_backend_login:
		handle_backend_login.login(username, password)
		handle_backend_login.connect("login_success", Callable(self, "_on_user_logged_in_successfully"))
		handle_backend_login.connect("login_failed", Callable(self, "_on_login_failed"))
	else:
		_set_status_message("Backend login handler is not available", Color.RED)

# Called when the user successfully logs in
func _on_user_logged_in_successfully(session_token: String):
	_set_status_message("Login successful!", Color.GREEN)
	print("Session token received: ", session_token)

# Called when the login process fails
func _on_login_failed(reason: String):
	_set_status_message("Login failed: " + reason, Color.RED)
	print("Login failed due to: ", reason)


# Update the status label with a message and color
func _set_status_message(message: String, color: Color):
	status_label.text = message
	status_label.modulate = color
