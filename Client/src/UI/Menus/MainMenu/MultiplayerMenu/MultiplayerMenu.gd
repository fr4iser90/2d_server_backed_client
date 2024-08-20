extends Control

@onready var ip_input = $MultiPlayer/IPInput
@onready var port_input = $MultiPlayer/PortInput
@onready var connect_button = $MultiPlayer/Connect
@onready var back_button = $MultiPlayer/Back
@onready var status_label = $MultiPlayer/Status

var enet_peer: ENetMultiplayerPeer
var is_connected = false

var default_ip = "127.0.0.1"
var default_port = 9997
var menu_manager: MenuManager = null

func _ready():
	print("Multiplayer ready")

	# Finde den MenuManager in der Baum-Hierarchie
	# Stelle sicher, dass du die Methode auf dem richtigen Knoten aufrufst
	menu_manager = get_tree().get_root().get_node("MenuManager") as MenuManager

	if not menu_manager:
		print("MenuManager not found. Please ensure it is added to the scene tree.")
	else:
		print("Using existing MenuManager instance")

	# Setze Standard-IP und -Port, falls die Eingabefelder leer sind
	if ip_input.text == "":
		ip_input.text = default_ip
	if port_input.text == "":
		port_input.text = str(default_port)

	connect_button.grab_focus()

	connect_button.connect("pressed", Callable(self, "_on_ConnectButton_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))

func connect_to_server(ip: String, port: int):
	enet_peer = ENetMultiplayerPeer.new()
	var err = enet_peer.create_client(ip, port)

	if err == OK:
		print("Attempting to connect to server at ", ip, ":", port)
		status_label.text = "Connecting to server at " + ip + ":" + str(port)
		multiplayer.multiplayer_peer = enet_peer
		set_process(true)  # Beginne das Überwachen des Verbindungsstatus
	else:
		print("Failed to start connection to server, error code: ", err)
		status_label.text = "Failed to start connection, error code: " + str(err)

func _process(delta):
	if enet_peer:
		var status = enet_peer.get_connection_status()
		print("Current ENet client status: ", status)

		if status == ENetMultiplayerPeer.CONNECTION_CONNECTED:
			if not is_connected:
				print("Connected to server successfully")
				status_label.text = "Connected to server successfully!"
				is_connected = true
				set_process(false)  # Stoppe das Überwachen des Verbindungsstatus
				load_login_menu_scene()
		elif status == ENetMultiplayerPeer.CONNECTION_DISCONNECTED:
			if is_connected:
				print("Disconnected from server.")
				status_label.text = "Disconnected from server."
				is_connected = false
				set_process(false)

func load_login_menu_scene():
	if menu_manager:
		menu_manager.show_menu("LoginMenu")

func _on_ConnectButton_pressed():
	var ip = ip_input.text.strip_edges()
	var port = int(port_input.text.strip_edges())
	if ip == "":
		ip = default_ip
	if port_input.text == "":
		port = default_port
	connect_to_server(ip, port)

func _on_back_pressed():
	if menu_manager:
		menu_manager.show_menu("MainMenu")
