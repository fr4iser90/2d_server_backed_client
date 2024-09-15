# res://src/core/game_manager/world_manager/InstanceManager.gd (Server)
extends Node

var instances = {}  # Speichert alle Instanzen und deren Spieler
var instance_scene_map = {}  # Mappt Instance Keys zu Scene Names
var max_players_per_instance = 20
signal instance_created(instance_key: String)

var is_initialized = false

# Initialize the InstanceManager
func initialize():
	if is_initialized:
		print("InstanceManager already initialized. Skipping.")
		return
	is_initialized = true

# Funktion, um einen Spieler basierend auf den ausgewählten Charakterdaten zu spawnen
func handle_player_character_selected(peer_id: int, character_data: Dictionary):
	print("InstanceManager: Handling character selection for peer_id: ", peer_id)

	# Extrahiere die notwendigen Daten aus dem character_data-Dictionary
	var scene_name = character_data.get("scene_name", "")
	var spawn_point = character_data.get("spawn_point", "")
	var character_class = character_data.get("character_class", "")

	if scene_name != "" and spawn_point != "" and character_class != "":
		# Spieler in eine Instanz zuweisen
		var instance_key = assign_player_to_instance(scene_name, {
			"peer_id": peer_id,
			"character_class": character_class,
			"player_node": character_data.get("player_node")
		})
		if instance_key != "":
			# Hier verwenden wir den PlayerManager zum Spawnen des Charakters
			var player_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "player_manager")
			
			if player_manager:
				# Dynamische Datenübergabe an den PlayerManager
				player_manager.handle_player_spawn(peer_id, character_data)
			else:
				print("Error: PlayerManager not found.")
		else:
			print("Error: Could not assign player to an instance.")
	else:
		print("Error: Invalid character data.")


# Erstellt eine neue Instanz oder gibt eine vorhandene Instanz zurück
func create_instance(scene_name: String) -> String:
	var scene_path = GlobalManager.GlobalSceneManager.get_scene_path(scene_name)
	print("Creating instance with scene_name:", scene_name, " searched path: ", scene_path)

	if scene_path == "":
		print("Error: Couldn't create instance. Scene path not found for scene name:", scene_name)
		return ""

	var scene_resource = load(scene_path)
	if scene_resource == null:
		print("Error: Could not load the scene from path:", scene_path)
		return ""

	var scene_instance = scene_resource.instantiate()
	if scene_instance == null:
		print("Error: Could not instantiate the scene from path:", scene_path)
		return ""

	# Finde den nächsten freien Instance Key
	var instance_id = str(instances.size() + 1)
	var instance_key = scene_path + ":" + instance_id

	# Speichere die Instanz und mappe sie zu der Szene
	instances[instance_key] = {
		"scene_path": scene_path,
		"players": [],
		"scene_instance": scene_instance
	}
	instance_scene_map[instance_key] = scene_name

	emit_signal("instance_created", instance_key)

	# Zeige die Szene im Überwachungsfenster an
	var player_visual_monitor = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "player_visual_monitor")
	player_visual_monitor.show_scene_instnace_window(instance_key)
	#GlobalManager.GlobalSceneManager.show_scene_window(scene_instance)

	print("Instance created and scene loaded:", instance_key)
	return instance_key

# Funktion, um die Szene in einem Überwachungsfenster anzuzeigen
func load_and_display_scene(scene_instance: Node):
	GlobalManager.GlobalSceneManager.show_scene_window(scene_instance)
	if scene_instance != null:
		print("Scene loaded and displayed in popup: ", scene_instance.name)
	else:
		print("Error: Could not load and display scene.")

# Weise einen Spieler einer Instanz zu und starte die Synchronisation
func assign_player_to_instance(scene_name: String, player_data: Dictionary) -> String:
	var instance_key = create_instance(scene_name)
	if instance_key != "":
		instances[instance_key]["players"].append(player_data)
		print("Player assigned to instance: ", instance_key)

		var player_movement_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "player_movement_manager")
		if player_movement_manager:
			player_movement_manager.add_player(player_data["peer_id"], player_data["player_node"])
		
		start_sync_in_instance(instance_key)
		return instance_key
	print("Error: No spawn instance available to assign player.")
	return ""

# Startet die Synchronisation der Spielerbewegungen in der Instanz
func start_sync_in_instance(instance_id: String):
	if instances.has(instance_id):
		var player_movement_sync_handler = GlobalManager.GlobalNodeManager.get_node_from_config("basic_handler", "player_movement_sync_handler")
		# Ändere den Aufruf zu einem gültigen Argument (übergebe `instance_id` direkt)
		player_movement_sync_handler.handle_packet({}, instance_id)

# Weise einen Spieler einer Instanz zu
func assign_player_to_scene_and_instance(peer_id: int, scene_name: String, player_data: Dictionary):
	var instance_key = assign_player_to_instance(scene_name, player_data)
	if instance_key != "":
		var player_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "player_manager")
		if player_manager:
			player_manager.handle_player_spawn(peer_id, player_data)
		else:
			print("Error: PlayerManager not found.")
	else:
		print("Error: Could not assign player to an instance.")

# Abfragen der Szene anhand des Instance Keys
func get_scene_for_instance(instance_key: String) -> String:
	return instance_scene_map.get(instance_key, "Unknown Scene")
