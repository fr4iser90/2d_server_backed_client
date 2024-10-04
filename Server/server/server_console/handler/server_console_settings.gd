# res://src/core/server/config/server_console_settings.gd
extends Node

var config_file_path = "res://user/config/console.cfg"

# Save the CheckButton state to the config file
func save_settings(auto_connect_enabled: bool):
	var config = ConfigFile.new()
	config.set_value("General", "AutoConnect", auto_connect_enabled)
	var err = config.save(config_file_path)
	if err == OK:
		print("Settings saved: AutoConnect =", auto_connect_enabled)
	else:
		print("Error saving settings:", err)

# Load the CheckButton state from the config file
func load_settings() -> bool:
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err == OK:
		var auto_connect_enabled = config.get_value("General", "AutoConnect", false)
		print("Settings loaded: AutoConnect =", auto_connect_enabled)
		return auto_connect_enabled
	else:
		print("Error loading settings or no settings file found, using default settings.")
		return false
