# res://src/core/server/preset/default/server_init.gd
extends Node

var server_init_manager: Node
var network_manager_loader: Node
var backend_connection_handler: Node

func _ready():
	# Lade die modularen Skripte
	server_init_manager = load("res://src/core/server/preset/default/server_init_manager.gd").new()
	network_manager_loader = load("res://src/core/server/preset/default/network_manager_loader.gd").new()
	backend_connection_handler = load("res://src/core/server/preset/default/backend_connection_handler.gd").new()

	# Benenne die geladenen Instanzen für klare Identifikation
	server_init_manager.name = "ServerInitManager"
	network_manager_loader.name = "NetworkManagerLoader"
	backend_connection_handler.name = "BackendConnectionHandler"
	
	# Signale verbinden
	server_init_manager.connect("all_managers_initialized", Callable(network_manager_loader, "load_network_managers"))
	network_manager_loader.connect("managers_loaded", Callable(self, "_on_network_managers_loaded"))

	# Starte die Server-Initialisierung
	server_init_manager._ready()

func _on_network_managers_loaded():
	# Netzwerk-Manager geladen, aber Backend-Verbindung wird nicht hier gestartet
	print("Network managers loaded. Backend connection will be handled via UI.")
	#GlobalManager.NodeManager.scan_node_tree(get_tree().root)
