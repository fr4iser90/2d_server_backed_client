extends Node

@onready var database_port_input = $DatabasePortInput
@onready var start_database_button = $StartDatabaseButton
@onready var stop_database_button = $StopDatabaseButton
@onready var auto_start_check_button = $AutoStartCheckButton
@onready var web_socket_manager = $"../../../Source/WebSocketServer/Manager/WebSocketManager"

var config_file_path = "res://src/console/settings_container/database_settings.cfg"

# Load the settings when the scene is ready
func _ready():
	load_settings()

# Save the settings to the config file
func save_settings():
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err != OK:
		print("Error loading config file: ", err)
		return

	# Save the port and auto-start settings
	config.set_value("Database", "Port", database_port_input.text)
	config.set_value("Database", "AutoStart", auto_start_check_button.is_pressed())

	# Write the settings to the file
	err = config.save(config_file_path)
	if err == OK:
		print("Database settings saved successfully.")
	else:
		print("Error saving database settings: ", err)

# Load the settings from the config file without default values
func load_settings():
	var config = ConfigFile.new()
	var err = config.load(config_file_path)

	# Only load settings if the file exists
	if err != OK:
		print("Error loading config file: ", err)
		return
	else:
		# Load the existing settings
		database_port_input.text = config.get_value("Database", "Port", "")
		auto_start_check_button.set_pressed(config.get_value("Database", "AutoStart", false))

	# Log the loaded settings
	print("Loaded settings: Port = ", database_port_input.text, ", AutoStart = ", auto_start_check_button.is_pressed())

# Called when the database port is changed, save the updated port
func _on_database_port_input_text_changed(new_text):
	save_settings()

# Called when the auto-start button is toggled, save the updated setting
func _on_auto_start_check_button_toggled(toggled_on):
	save_settings()
	web_socket_manager.initialize_server()
	
# Called when the start button is pressed
func _on_start_database_button_pressed():
	# Start the database logic here
	print("Database starting...")
	# You may want to trigger saving here too
	save_settings()
	web_socket_manager.initialize_server()
	
# Called when the stop button is pressed
func _on_stop_database_button_pressed():
	# Stop the database logic here
	print("Database stopping...")
