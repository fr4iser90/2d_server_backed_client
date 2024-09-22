# res://src/core/client/scene/menu/launcher/DataManager.gd (Client)
extends Node

var config_file_path = "res://src/user/config/launcher.cfg"  

# Save last used server IP and port
func save_last_server_address(ip: String, port: int):
	var current_address = get_last_server_address()
	var current_ip_port = current_address.split(":")
	var current_ip = current_ip_port[0]
	var current_port = int(current_ip_port[1])

	if current_ip == ip and current_port == port:
		print("IP and Port are the same, no need to save.")
		return

	var config = ConfigFile.new()
	config.load(config_file_path)
	config.set_value("General", "ServerIP", ip)
	config.set_value("General", "ServerPort", port)
	config.save(config_file_path)
	print("Server address saved:", ip, port)

# Get last used server IP and port
func get_last_server_address() -> String:
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err == OK:
		var ip = config.get_value("General", "ServerIP", "127.0.0.1")
		var port = config.get_value("General", "ServerPort", 9997)
		return ip + ":" + str(port)
	else:
		print("Error loading settings or no settings file found, using default values.")
		return "127.0.0.1:9997"

# Save login credentials
func save_login_data(username: String, password: String):
	var config = ConfigFile.new()
	config.load(config_file_path)
	config.set_value("Login", "Username", username)
	config.set_value("Login", "Password", password)  # Be cautious storing passwords in plaintext
	config.save(config_file_path)

# Load login credentials
func load_login_data() -> Dictionary:
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err == OK:
		var username = config.get_value("Login", "Username", "")
		var password = config.get_value("Login", "Password", "")
		return {"username": username, "password": password}
	else:
		print("Error loading login settings, using default.")
		return {"username": "", "password": ""}

# Save auto-connect and auto-login preferences
func save_auto_connect(auto_connect: bool):
	var config = ConfigFile.new()
	config.load(config_file_path)
	config.set_value("General", "AutoConnect", auto_connect)
	config.save(config_file_path)

func save_auto_login(auto_login: bool):
	var config = ConfigFile.new()
	config.load(config_file_path)
	config.set_value("General", "AutoLogin", auto_login)
	config.save(config_file_path)

# Load auto-connect and auto-login preferences
func load_auto_connect() -> bool:
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err == OK:
		return config.get_value("General", "AutoConnect", false)
	else:
		print("Error loading AutoConnect setting, using default (false).")
		return false

func load_auto_login() -> bool:
	var config = ConfigFile.new()
	var err = config.load(config_file_path)
	if err == OK:
		return config.get_value("General", "AutoLogin", false)
	else:
		print("Error loading AutoLogin setting, using default (false).")
		return false
