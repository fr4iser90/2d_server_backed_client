# res://src/core/client/scene/menu/connection_menu.gd (Client)
extends Control

@onready var ip_input = $ConnectionMenuContainer/ServerIpInput
@onready var port_input = $ConnectionMenuContainer/ServerPortInput
@onready var connect_button = $ConnectionMenuContainer/ConnectButton
@onready var back_button = $ConnectionMenuContainer/BackButton
@onready var status_label = $ConnectionMenuContainer/StatusLabel

# Globale Referenzen
var network_module = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")

var menu_tree

func _ready():
	menu_tree = get_node("/root/Menu")
	# Standard-IP und -Port setzen
	if ip_input.text == "":
		ip_input.text = GlobalManager.GlobalConfig.get_server_ip()
	if port_input.text == "":
		port_input.text = str(GlobalManager.GlobalConfig.get_server_port())

	# Verwende den GlobalSceneManager, um den NetworkManager zu laden
	
	#network_module = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	var network_module = get_node("/root/Core/Network")
	if network_module:
		print("Network module found: ", network_module)
		print("Type of network_module: ", typeof(network_module))
		# Verbindungen zu den Signalen herstellen
		network_module.connect("network_manager_connected_to_server", Callable(self, "_on_connected"))
		network_module.connect("network_manager_disconnected_from_server", Callable(self, "_on_disconnected"))
		network_module.connect("network_manager_connection_failed", Callable(self, "_on_connection_failed"))
	else:
		print("Error: NetworkModule could not be loaded.")
	
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
	var network_module = get_node("/root/Core/Network")
	if network_module:
		network_module.connect_to_server()  # Verbindung herstellen
		status_label.text = "Connecting..."
	else:
		print("Error: NetworkModule is not available.")

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
	_free_current_scene()
	GlobalManager.SceneManager.put_scene_at_node("login_menu", "Menu")
	
func _free_current_scene():
	if menu_tree and menu_tree.get_child_count() > 0:
		var current_scene = menu_tree.get_child(0)  # Nimmt an, dass nur eine Szene in der "Menu" Node ist
		if current_scene:
			print("Freed scene: ", current_scene)
			current_scene.queue_free()  # Szene entfernen
