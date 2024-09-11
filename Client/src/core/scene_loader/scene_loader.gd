extends Node

var current_scene: Node = null

# Lädt die angegebene Szene vom Server und fügt sie dem Szenenbaum hinzu
func load_scene(scene_path: String) -> Node:
	var scene = load(scene_path)
	if scene != null:
		var instance = scene.instantiate()
		get_tree().root.add_child(instance)
		current_scene = instance
		print("Scene loaded: ", scene_path)
		return instance
	else:
		print("Failed to load scene: ", scene_path)
		return null

# Fügt den Spieler zur aktuellen Szene hinzu, basierend auf den vom Server empfangenen Daten
func add_player(player_data: Dictionary):
	if current_scene != null:
		var character_model_path = player_data.get("character_model_path", "")
		if character_model_path != "":
			var player_scene = load(character_model_path)
			if player_scene != null:
				var player_instance = player_scene.instantiate() as CharacterBody2D
				if player_instance is CharacterBody2D:
					player_instance.global_position = player_data.get("position", Vector2(0, 0))

					current_scene.add_child(player_instance)
					print("Player added to scene at position: ", player_instance.global_position)

					# Kamera für den Spieler setzen
					var camera = player_instance.get_node("camera_2d")
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

# Entfernt die aktuelle Szene, wenn der Spieler den Raum verlässt
func unload_current_scene():
	if current_scene != null:
		current_scene.queue_free()
		current_scene = null
		print("Current scene unloaded")
	else:
		print("No scene to unload")
