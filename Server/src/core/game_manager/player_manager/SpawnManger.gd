# res://src/core/network/game_manager/player_manager/spawn_manager.gd (Server)
extends Node

# Speichert die letzte bekannte Position von Spielern
var last_known_positions = {}

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	is_initialized = true
	

# Holt die Position für das Spawnen eines Spielers, basierend auf dem Spawn-Punkt oder der letzten Position
func get_spawn_position(peer_id: int, scene_instance: Node, spawn_point: String, use_last_position: bool = false) -> Vector2:
	# Wenn use_last_position true ist, hole die letzte bekannte Position
	if use_last_position and last_known_positions.has(peer_id):
		return last_known_positions[peer_id]

	# Ansonsten berechne die Spawn-Position vom SceneSpawnManager
	return GlobalManager.GlobalSceneManager.get_spawn_point(scene_instance, spawn_point)  # Wir übergeben direkt die Szene-Instanz



# Spawnt einen Spieler in der Szene
func spawn_player(peer_id: int, character_class: String, scene_instance: Node, spawn_point: String):
	print("SpawnManager: Spawning player with peer_id: ", peer_id)
	
	# Bestimme die Spawn-Position
	var spawn_position = get_spawn_position(peer_id, scene_instance, spawn_point)  # Übergibt die scene_instance direkt
	var player_movement_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "player_movement_manager")
	# Lade die Spieler-Charakterszene basierend auf der Klasse
	var character_scene_path = GlobalManager.GlobalSceneManager.scene_config.get_scene_path(character_class)
	var player_scene = load(character_scene_path)
	if player_scene and player_scene is PackedScene:
		var player_character = player_scene.instantiate()
		scene_instance.add_child(player_character)
		player_character.global_position = spawn_position
		player_movement_manager.add_player(peer_id, player_character)
		print("Player spawned at position: ", spawn_position)
	else:
		print("Error: Failed to load player character for class: ", character_class)


# Aktualisiere die letzte bekannte Position eines Spielers
func update_last_known_position(peer_id: int, position: Vector2):
	last_known_positions[peer_id] = position

# Lösche die letzte bekannte Position eines Spielers (z.B. beim Logout)
func clear_last_known_position(peer_id: int):
	if last_known_positions.has(peer_id):
		last_known_positions.erase(peer_id)
