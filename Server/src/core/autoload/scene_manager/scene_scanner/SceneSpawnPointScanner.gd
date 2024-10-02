# SceneSpawnPointScanner.gd
extends Node

# Verzeichnis zum Scannen der Szenen
var start_directory = "res://shared/data/levels"  # Nur Szenen im 'levels'-Verzeichnis scannen

# Dictionary, um die Pfade von kategorisierten SpawnPoints zu speichern
var spawn_point_data = {}

# Szenen scannen für spezifische SpawnPoints (Player, NPC, Mob)
func scan_scenes_for_spawn_points():
	var scenes = get_scene_paths(start_directory)
	for scene_name in scenes.keys():
		var scene_path = scenes[scene_name]
		print("Scanning scene:", scene_name)
		_find_spawn_points_in_scene(scene_name, scene_path)

# Funktion zum rekursiven Durchlaufen der Ordner und Erfassen der Szenenpfade
func get_scene_paths(directory: String) -> Dictionary:
	var dir = DirAccess.open(directory)
	var scenes = {}

	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				var sub_scenes = get_scene_paths(directory + "/" + file_name)
				for key in sub_scenes.keys():
					scenes[key] = sub_scenes[key]
			elif file_name.ends_with(".tscn"):
				var scene_name = file_name.replace(".tscn", "")
				scenes[scene_name] = directory + "/" + file_name
			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Fehler beim Öffnen des Verzeichnisses:", directory)

	return scenes

# Bestimmte Szene scannen für SpawnPoints
func _find_spawn_points_in_scene(scene_name: String, scene_path: String):
	# Szene laden
	var packed_scene = load(scene_path)
	if packed_scene is PackedScene:
		var scene_instance = packed_scene.instantiate()

		# Suchen nach dem Hauptknoten: SpawnPoint
		var spawn_point_node = scene_instance.get_node_or_null("SpawnPoint")

		# Wenn kein SpawnPoint vorhanden ist, Szene überspringen
		if spawn_point_node == null:
			print("Skipping scene: ", scene_name, " | No SpawnPoint found.")
			return

		# Initialisiere kategorisierte SpawnPoints
		var categorized_spawn_points = {
			"player_spawn_points": {},
			"npc_spawn_points": {},
			"mob_spawn_points": {}
		}

		# Wenn SpawnPoint-Knoten vorhanden, Unterknoten durchsuchen
		if spawn_point_node:
			print("Scanning SpawnPoints in scene: ", scene_name)
			_find_spawn_points_recursive(spawn_point_node, categorized_spawn_points)

		# Speichern nur, wenn gültige SpawnPoints gefunden wurden
		if categorized_spawn_points["player_spawn_points"].size() > 0 or categorized_spawn_points["npc_spawn_points"].size() > 0 or categorized_spawn_points["mob_spawn_points"].size() > 0:
			spawn_point_data[scene_name] = categorized_spawn_points
			print("Found categorized spawn points for scene:", scene_name, categorized_spawn_points)
		else:
			print("No spawn points found in scene:", scene_name)
	else:
		print("Fehler: Szene konnte nicht geladen werden oder ist keine PackedScene:", scene_name)


# Rekursiv kategorisierte SpawnPoints in einem Node und dessen Kindern finden
func _find_spawn_points_recursive(node: Node, categorized_spawn_points: Dictionary):
	for child in node.get_children():
		# Überprüfen, ob der Knoten ein Node2D ist, der als Parent fungiert
		if child is Node2D:
			if child.name.find("PlayerSpawnPoint") != -1:
				# Jetzt die Kinder von PlayerSpawnPoint durchsuchen, um Marker2D zu finden
				for marker in child.get_children():
					if marker is Marker2D:
						print("Found PlayerSpawnPoint marker:", marker.name)
						categorized_spawn_points["player_spawn_points"][marker.name] = marker.global_position
			elif child.name.find("NPCSpawnPoint") != -1:
				# Jetzt die Kinder von NPCSpawnPoint durchsuchen, um Marker2D zu finden
				for marker in child.get_children():
					if marker is Marker2D:
						print("Found NPCSpawnPoint marker:", marker.name)
						categorized_spawn_points["npc_spawn_points"][marker.name] = marker.global_position
			elif child.name.find("MobSpawnPoint") != -1:
				# Jetzt die Kinder von MobSpawnPoint durchsuchen, um Marker2D zu finden
				for marker in child.get_children():
					if marker is Marker2D:
						print("Found MobSpawnPoint marker:", marker.name)
						categorized_spawn_points["mob_spawn_points"][marker.name] = marker.global_position

		# Rekursiv alle Kinder des aktuellen Knotens durchsuchen
		_find_spawn_points_recursive(child, categorized_spawn_points)


# Utility zum Abrufen der SpawnPoints für eine spezifische Szene
func get_spawn_points_for_scene(scene_name: String) -> Dictionary:
	return spawn_point_data.get(scene_name, {})

# Die gesammelten SpawnPoints in einer Datei speichern (optional)
func save_spawn_points_to_file(output_file: String):
	var file = FileAccess.open(output_file, FileAccess.WRITE)
	if file != null:
		# SpawnPoints in der Datei speichern
		var content = JSON.stringify(spawn_point_data)  # Verwende JSON.stringify() um das Dictionary in einen JSON-String zu konvertieren
		file.store_string(content)
		file.close()
		print("Spawn points saved to file:", output_file)
	else:
		print("Error opening file for writing:", output_file)
