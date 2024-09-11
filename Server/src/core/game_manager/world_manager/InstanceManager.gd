# res://src/core/network/game_manager/world_manager/instance_manager.gd
extends Node

var instances = {}
var max_players_per_instance = 20
signal instance_created(instance_key: String)

var spawn_instance_key = null
var is_initialized = false

# Fetch the Spawn Manager


func initialize():
	if is_initialized:
		print("InstanceManager already initialized. Skipping.")
		return
	# Prüfe, ob der SpawnManager korrekt geladen wurde
	is_initialized = true

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

	for key in instances.keys():
		if instances[key]["scene_path"] == scene_path:
			print("Instance already exists for:", scene_path)
			return key

	var instance_id = str(instances.size() + 1)
	var instance_key = scene_path + ":" + instance_id

	instances[instance_key] = {
		"scene_path": scene_path,
		"players": [],
		"scene_instance": scene_instance
	}

	emit_signal("instance_created", instance_key)

	# Hier wird die Szene im Überwachungsfenster geladen
	load_and_display_scene(scene_instance)  # Diese Zeile zeigt die Szene im Überwachungsfenster an.

	print("Instance created and scene loaded:", instance_key)
	return instance_key

# Funktion, um die Szene in einem Überwachungsfenster anzuzeigen
func load_and_display_scene(scene_instance: Node):
	# Verwende den GlobalSceneManager, um die Szene in einem Fenster zu zeigen
	GlobalManager.GlobalSceneManager.show_scene_window(scene_instance)  # Show Window
	if scene_instance != null:
		print("Scene loaded and displayed in popup: ", scene_instance.name)
	else:
		print("Error: Could not load and display scene.")


# Weise einen Spieler einer Instanz zu
func assign_player_to_instance(scene_name: String, player_data: Dictionary) -> String:
	if spawn_instance_key != null:
		instances[spawn_instance_key]["players"].append(player_data)
		print("Player assigned to global spawn instance: ", spawn_instance_key)
		return spawn_instance_key

	var instance_key = create_instance(scene_name)
	if instance_key:
		instances[instance_key]["players"].append(player_data)
		print("Player assigned to instance: ", instance_key)
		return instance_key

	print("Error: No spawn instance available to assign player.")
	return ""

# Delegiere das Spawnen eines Spielers an den SpawnManager
func handle_player_character_selected(peer_id: int, scene_name: String, spawn_point: String, character_class: String):
	print("InstanceManager: Handling character selection for peer_id: ", peer_id)

	# Spieler in eine Instanz zuweisen
	var instance_key = assign_player_to_instance(scene_name, {"peer_id": peer_id, "character_class": character_class})
	if instance_key != "":
		# Verwende den SpawnManager zum Spawnen des Charakters
		var scene_instance = instances[instance_key]["scene_instance"]
		var spawn_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "spawn_manager")

		# Hier übergeben wir die Szene-Instanz anstelle des Szenennamens
		spawn_manager.spawn_player(peer_id, character_class, scene_instance, spawn_point)
	else:
		print("Error: Could not assign player to an instance.")
