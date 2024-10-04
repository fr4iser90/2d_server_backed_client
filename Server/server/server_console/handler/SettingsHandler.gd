# ServerConsoleSettings.gd
extends Node

var config_file_path = "res://user/config/console.cfg"

# Speichere nur die AutoConnect-Daten
func save_auto_connect(auto_connect_enabled: bool):
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	
	if err != OK:
		print("Error loading config file:", err)
		return
	
	config.set_value("AutoConnect", "AutoConnectDatabase", auto_connect_enabled)

	err = config.save(config_file_path)
	
	if err == OK:
		print("AutoConnect settings saved successfully.")
	else:
		print("Error saving AutoConnect settings:", err)

# Speichere nur die AutoStart-Daten
func save_auto_start(auto_start_server_enabled: bool):
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	
	if err != OK:
		print("Error loading config file:", err)
		return
	
	config.set_value("AutoStart", "AutoStartServer", auto_start_server_enabled)

	err = config.save(config_file_path)
	
	if err == OK:
		print("AutoStart settings saved successfully.")
	else:
		print("Error saving AutoStart settings:", err)

# Speichere nur die Preset-Auswahl
func save_preset(selected_preset: int):
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	
	if err != OK:
		print("Error loading config file:", err)
		return
	
	config.set_value("Preset", "SelectedPreset", selected_preset)

	err = config.save(config_file_path)
	
	if err == OK:
		print("Preset settings saved successfully.")
	else:
		print("Error saving Preset settings:", err)


# Lade die gespeicherten Einstellungen
func load_settings() -> Dictionary:
	var config = ConfigFile.new()
	var settings = {}
	var err = config.load(config_file_path)
	if err == OK:
		settings["auto_connect_enabled"] = config.get_value("AutoConnect", "AutoConnectDatabase", false)
		settings["auto_start_server_enabled"] = config.get_value("AutoStart", "AutoStartServer", false)
		settings["selected_preset"] = config.get_value("Preset", "SelectedPreset", 0)  # Standardmäßig MongoDB REST
		return settings
	else:
		print("Error loading settings or no settings file found.")
		return {}  # Gib ein leeres Dictionary zurück, wenn nichts gefunden wird

