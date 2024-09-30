# res://src/core/server/preset/database_godot/server_init.gd
extends Node

var preset_name = "database_godot"
var server_init_manager: Node
var network_manager_loader: Node
var backend_connection_handler: Node

func _ready():
	# Lade die modularen Skripte
	server_init_manager = load("res://src/core/server/preset/database_godot/server_init_manager.gd").new()
	network_manager_loader = load("res://src/core/server/preset/database_godot/network_manager_loader.gd").new()

	# Benenne die geladenen Instanzen für klare Identifikation
	server_init_manager.name = "ServerInitManager"
	network_manager_loader.name = "NetworkManagerLoader"
	
	# Signale verbinden
	server_init_manager.connect("all_managers_initialized", Callable(network_manager_loader, "load_network_managers"))
	network_manager_loader.connect("managers_loaded", Callable(self, "_on_network_managers_loaded"))

	# Starte die Server-Initialisierung
	server_init_manager._ready()

func _on_network_managers_loaded():
	print("Network managers loaded. Backend connection will be handled via UI.")

