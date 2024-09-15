extends Control

@onready var ip_input = $ConnectionMenuContainer/ServerIpInput
@onready var port_input = $ConnectionMenuContainer/ServerPortInput
@onready var connect_button = $ConnectionMenuContainer/ConnectButton
@onready var back_button = $ConnectionMenuContainer/BackButton
@onready var status_label = $ConnectionMenuContainer/StatusLabel

# Globale Referenzen
var network_manager = null

func _ready():
	# Standard-IP und -Port setzen
	if ip_input.text == "":
		ip_input.text = GlobalManager.GlobalConfig.get_server_ip()
	if port_input.text == "":
		port_input.text = str(GlobalManager.GlobalConfig.get_server_port())

	# Verwende den GlobalSceneManager, um den NetworkManager zu laden
	network_manager = GlobalManager.SceneManager.load_scene("network_manager")
	
	if network_manager:
		# Verbindungen zu den Signalen herstellen
		network_manager.connect("network_manager_connected_to_server", Callable(self, "_on_connected"))
		network_manager.connect("network_manager_disconnected_from_server", Callable(self, "_on_disconnected"))
		network_manager.connect("network_manager_connection_failed", Callable(self, "_on_connection_failed"))
	else:
		print("Error: NetworkManager could not be loaded.")
	
	connect_button.grab_focus()
	connect_button.connect("pressed", Callable(self, "_on_connect_button_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))

func _on_connect_button_pressed():
	var ip = ip_input.text.strip_edges()
	var port = int(port_input.text.strip_edges())
	
	if ip == "":
		ip = GlobalManager.GlobalConfig.get_server_ip()
	if port_input.text == "":
		port = GlobalManager.GlobalConfig.get_server_port()

	if network_manager:
		network_manager.connect_to_server()  # Verbindung herstellen
		status_label.text = "Connecting..."
	else:
		print("Error: NetworkManager is not available.")

func _on_connected():
	status_label.text = "Connected to server successfully!"
	_load_login_menu_scene()

func _on_disconnected():
	status_label.text = "Disconnected from server."

func _on_connection_failed():
	status_label.text = "Failed to connect to server."

func _on_back_button_pressed():
	GlobalManager.SceneManager.switch_scene("main_menu")

func _load_login_menu_scene():
	GlobalManager.SceneManager.switch_scene("login_menu")
