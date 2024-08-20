extends Node

var network_manager = null
var enet_client_manager = null
var player_manager = null
var scene_manager = null
var player_movement_manager = null
var player_list = null

var selected_character = null
var auth_token = ""

func initialize(character, token):
	print("Initializing ClientMain with character and token")
	selected_character = character
	auth_token = token
	
	# Load and instance the core system scenes
	network_manager = load("res://src/Core/Network/NetworkManager.tscn").instantiate()
	enet_client_manager = load("res://src/Core/Network/ENetClientManager.tscn").instantiate()
	player_manager = load("res://src/Core/PlayerManagement/PlayerManager.tscn").instantiate()
	scene_manager = load("res://src/Core/SceneLoader/SceneLoader.tscn").instantiate()
	player_movement_manager = load("res://src/Core/PlayerManagement/PlayerMovement/PlayerMovement.gd").new()
	
	# Load the PlayerList script safely
	var player_list_script = load("res://src/Data/Characters/Players/PlayerList.gd")
	if player_list_script != null:
		player_list = player_list_script.new()
	else:
		print("Error: Could not load PlayerList script.")
		return
	
	# Add core systems to the scene tree
	add_child(network_manager)
	add_child(player_manager)
	add_child(scene_manager)
	add_child(enet_client_manager)
	add_child(player_movement_manager) 
	add_child(player_list)

	# Initialize network after adding it to the scene tree
	if network_manager and is_instance_valid(network_manager):
		print("NetworkManager initialized successfully")
		start_game()
	else:
		print("Error: NetworkManager is not initialized")

func start_game():
	print("Starting game, attempting to connect to server...")
	# Set up ENetClientManager for real-time communication
	
	# Verbinde das Signal mit der Methode
	var connected_signal = Callable(self, "_on_connected_to_server")
	if not enet_client_manager.is_connected("connected_to_server", connected_signal):
		print("Connecting signal 'connected_to_server' to _on_connected_to_server")
		enet_client_manager.connect("connected_to_server", connected_signal)
	else:
		print("Signal 'connected_to_server' is already connected")
		
func _on_connected_to_server():
	print("Connected to server, attempting to set network peer...")

	if enet_client_manager and enet_client_manager.enet_peer:
		var multiplayer = get_tree().get_multiplayer()
		if multiplayer:
			multiplayer.set_multiplayer_peer(enet_client_manager.enet_peer)
			print("Network peer set successfully.")
			# Setze den Spielernamen auf dem Server
			var username = selected_character["name"]
			# RPC-Aufruf zur Server-Methode
			rpc_id(1, "set_player_name", multiplayer.get_unique_id(), username)
			# Debug: Überprüfen, ob RPC-Aufruf wie erwartet funktioniert
			print("RPC call to set player name was issued.")
			# Rufe den Pfad des Charakters ab und lade die Szene
			var model_path = player_list.get_model_path(selected_character.class)
			if model_path != "":
				selected_character["character_model_path"] = model_path
				
				# Extrahiere den Szenenpfad aus selected_character
				var scene_path = selected_character["last_scene"]["path"]
				if scene_path != "":
					# Lade die Szene
					var loaded_scene = scene_manager.load_scene(scene_path)
					if loaded_scene != null:
						# Füge den Spieler zur geladenen Szene hinzu
						scene_manager.add_player(selected_character)
					else:
						print("Error: Failed to load scene.")
				else:
					print("Error: No scene path found in selected_character")
			else:
				print("Error: No model path found for character class ", selected_character.class)
		else:
			print("Error: Multiplayer is not ready.")
	else:
		print("Failed to set network peer, ENetClientManager not valid or enet_peer is null.")

