extends Node

var current_scene: Node = null

# Lädt die angegebene Szene und fügt sie dem Szenenbaum hinzu
func load_scene(scene_path: String) -> Node:
	# Lädt die Szene, die der Spieler ausgewählt hat
	var scene = load(scene_path)
	if scene != null:
		var instance = scene.instantiate()
		get_tree().root.add_child(instance)
		get_tree().current_scene = instance
		current_scene = instance  # Setzt die aktuelle Szene
		return instance
	else:
		print("Failed to load scene: ", scene_path)
		return null

func add_player(player_data: Dictionary):
	if current_scene != null:
		# Zugriff auf das Modell des Charakters aus player_data
		var character_model_path = player_data.get("character_model_path", "")
		if character_model_path != "":
			var player_scene = load(character_model_path)
			if player_scene != null:
				var player_instance = player_scene.instantiate() as CharacterBody2D

				# Stelle sicher, dass player_instance ein CharacterBody2D ist
				if player_instance is CharacterBody2D:
					# Finde den dynamischen Spawnpunkt aus den Spielerdaten
					var spawn_point_name = player_data.get("last_scene", {}).get("spawn_point", "DefaultSpawnPoint")
					print("Looking for dynamic spawn point:", spawn_point_name)
					var spawn_point_node = current_scene.get_node(spawn_point_name) as Node2D
					
					if spawn_point_node != null:
						player_instance.global_position = spawn_point_node.global_position
						print("Spawned player at dynamic spawn point: ", spawn_point_name, " with position: ", spawn_point_node.global_position)
					else:
						print("Dynamic spawn point not found, using default position")
						player_instance.global_position = Vector2(0, 0)

					current_scene.add_child(player_instance)
					print("Player added to scene at position: ", player_instance.global_position)

					# Kamera auf den Spieler ausrichten
					var camera = player_instance.get_node("Camera2D")
					if camera:
						camera.make_current()

				else:
					print("Error: player_instance is not a CharacterBody2D.")
			else:
				print("Error loading player model")
		else:
			print("No character model path provided in player data")
	else:
		print("No active scene to add player")



# Fügt ein Entity zur Szene hinzu
func add_entity(entity_data: Dictionary):
	if current_scene != null:
		var entity_scene = load(entity_data["scene_path"])
		if entity_scene != null:
			var entity_instance = entity_scene.instantiate()
			entity_instance.global_position = Vector2(entity_data["position"]["x"], entity_data["position"]["y"])
			current_scene.add_child(entity_instance)
			print("Entity added to scene")
		else:
			print("Error loading entity scene")
	else:
		print("No active scene to add entity")
