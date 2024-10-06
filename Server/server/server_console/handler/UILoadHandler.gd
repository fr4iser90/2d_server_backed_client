# res://src/core/server/server_console/reference_modules.gd
extends Node

# Define color constants using hex codes or built-in Color names
const color_connected = "[color=#0000FF]"  # Blue
const color_disconnected = "[color=#FF0000]"  # Red
const color_authentication_successful = "[color=#00FF00]"  # Green
const color_authentication_failed = "[color=#FF0000]"  # Red

@onready var server_backend_panel_label = $"../../ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanelLabel"

@onready var server_preset_list = $"../../ServerConsoleContainer/TopStartServer/ServerPresetList"
@onready var start_server_button = $"../../ServerConsoleContainer/TopStartServer/StartServerButton"
@onready var stop_server_button = $"../../ServerConsoleContainer/TopStartServer/StopServerButton"
@onready var server_port_input = $"../../ServerConsoleContainer/TopStartServer/ServerPortInput"
@onready var server_auto_start_check_button = $"../../ServerConsoleContainer/TopStartServer/ServerAutoStartCheckButton"

@onready var backend_ip_input = $"../../ServerConsoleContainer/TopBackend/BackendIPInput"
@onready var backend_port_input = $"../../ServerConsoleContainer/TopBackend/BackendPortInput"
@onready var server_validation_token_input = $"../../ServerConsoleContainer/TopBackend/ServerValidationTokenInput"
@onready var connect_to_backend = $"../../ServerConsoleContainer/TopBackend/ConnectToBackend"
@onready var disconnect_from_backend = $"../../ServerConsoleContainer/TopBackend/DisconnectFromBackend"
@onready var database_label = $"../../ServerConsoleContainer/Mid/ConsoleContainer/DatabaseLabel"

func _ready():
	# Ensure that BBCode is enabled for the label
	database_label.bbcode_enabled = true

# Load when disconnected
func load_on_disconnected():
	connect_to_backend.show()
	disconnect_from_backend.hide()
	# Use bbcode_text to apply color formatting
	database_label.bbcode_text = color_disconnected + "Backend: Status Disconnected[/color]"

	# Enable elements for user interaction
	server_preset_list.set_disabled(false)
	start_server_button.set_disabled(false)
	stop_server_button.set_disabled(false)
	server_port_input.editable = true
	backend_ip_input.editable = true
	backend_port_input.editable = true
	server_validation_token_input.editable = true

# Load when connected
func load_on_connecting():
	connect_to_backend.hide()
	disconnect_from_backend.show()
	# Use bbcode_text to apply color formatting
	database_label.bbcode_text = color_connected + "Backend: Status Connecting[/color]"

	# Disable the item list and other UI elements
	disable_item_list(server_preset_list, true)
	start_server_button.set_disabled(true)
	stop_server_button.set_disabled(true)
	server_port_input.set_editable(false)
	backend_ip_input.set_editable(false)
	backend_port_input.set_editable(false)
	server_validation_token_input.set_editable(false)

func disable_item_list(item_list: ItemList, disabled: bool):
	for i in range(item_list.get_item_count()):
		item_list.set_item_disabled(i, disabled)

# Load when authentication is successful
func load_on_server_authentication_successful():
	connect_to_backend.hide()
	disconnect_from_backend.show()
	# Use bbcode_text to apply color formatting
	database_label.bbcode_text = color_authentication_successful + "Backend: Status Authentication Successful[/color]"

	# Disable elements after successful authentication (keep them frozen)
	disable_item_list(server_preset_list, true)
	start_server_button.set_disabled(true)
	stop_server_button.set_disabled(true)
	server_port_input.editable = false
	backend_ip_input.editable = false
	backend_port_input.editable = false
	server_validation_token_input.editable = false

# Load when authentication fails
func load_on_server_authentication_failed():
	connect_to_backend.show()
	disconnect_from_backend.hide()
	# Use bbcode_text to apply color formatting
	database_label.bbcode_text = color_authentication_failed + "Backend: Status Authentication Failed[/color]"

	# Enable elements for retry
	disable_item_list(server_preset_list, false)
	start_server_button.set_disabled(false)
	stop_server_button.set_disabled(false)
	server_port_input.editable = true
	backend_ip_input.editable = true
	backend_port_input.editable = true
	server_validation_token_input.editable = true
