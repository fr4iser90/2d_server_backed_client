extends Node

# Globale Variablen
const SERVER_PORT = 9997

# Referenzen auf Kernmanager-Szenen
@onready var network_manager_scene = preload("res://src/Core/NetworkManagement/NetworkManager.tscn")
@onready var player_movement_manager_scene = preload("res://src/Core/PlayerManagement/PlayerMovement.tscn")

# Andere Manager als Skripte laden
@onready var player_manager = preload("res://src/Core/PlayerManagement/PlayerManager.gd").new()
@onready var scene_manager = preload("res://src/Core/SceneManagement/SceneManager.gd").new()
@onready var instance_manager = preload("res://src/Core/SceneManagement/InstanceManager.gd").new()
@onready var auth_token_manager = preload("res://src/Core/AuthenticationManagement/AuthTokenManager.gd").new()
@onready var auth_server_manager = preload("res://src/Core/AuthenticationManagement/AuthServerManager.gd").new()

# Halte Referenzen auf die Manager
var network_manager
var player_movement_manager

func _ready():
	# Szenen instanziieren
	network_manager = network_manager_scene.instantiate()
	player_movement_manager = player_movement_manager_scene.instantiate()
	print("NetworkManager: ", network_manager)
	print("PlayerMovementManager: ", player_movement_manager)
	
	# Core-Systeme initialisieren
	add_child(scene_manager)
	add_child(instance_manager)
	add_child(auth_token_manager)
	add_child(auth_server_manager)
	add_child(network_manager)  # Füge die instanziierten Knoten hinzu
	add_child(player_manager)
	add_child(player_movement_manager)  # Füge die instanziierten Knoten hinzu

	# Überprüfen, ob die Knoten existieren und richtig initialisiert wurden
	if not network_manager or not player_movement_manager:
		print("NetworkManager or PlayerMovementManager not found!")
		return
	
	# Manager initialisieren
	player_manager.init(scene_manager, instance_manager)
	
	# AuthServerManager initialisieren
	auth_server_manager.authenticate_server()
	
	# ENet-Server nach dem Hinzufügen zur Szene starten
	network_manager.start_server(SERVER_PORT)
	
	# Übergabe der enet_peer-Instanz an den PlayerMovementManager
	player_movement_manager.init(network_manager.enet_peer)
	
	# Verbinde das Signal vom AuthTokenManager
	auth_token_manager.connect("token_validated", Callable(self, "_on_token_validated"))
	
	# Verbinde das Signal für Spielerbewegungsaktualisierungen
	player_movement_manager.connect("player_position_updated", Callable(self, "_on_player_position_updated"))

	print("Server is ready and initialized")

func _on_token_validated(peer_id: int, success: bool):
	if success:
		print("Token validated successfully for peer: ", peer_id)
	else:
		print("Token validation failed for peer: ", peer_id)

func _on_player_position_updated(peer_id: int, new_position: Vector2):
	print("Player position updated: ", peer_id, new_position)

func log_error(message: String):
	print("ERROR: " + message)
	# Erweiterte Log-Funktionalität kann hier hinzugefügt werden.
