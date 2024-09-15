# res://src/core/network/game_manager/player_manager/spawn_manager.gd
extends Node

# Speichert die letzte bekannte Position von Spielern
var last_known_positions = {}

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	is_initialized = true
	
# Gets the spawn point from a scene or returns the last known position
func get_spawn_point(scene_instance: Node, spawn_point: String) -> Vector2:
	if scene_instance.has_node(spawn_point):
		var spawn_node = scene_instance.get_node(spawn_point)
		return spawn_node.global_position
	else:
		print("Error: Spawn point not found in the scene.")
		# Return a default position if spawn point is not found
		return Vector2(100, 100)

# Gets the spawn position, either the last known position or the specified spawn point
func get_spawn_position(peer_id: int, scene_instance: Node, spawn_point: String, use_last_position: bool) -> Vector2:
	if use_last_position and last_known_positions.has(peer_id):
		return last_known_positions[peer_id]
	else:
		return get_spawn_point(scene_instance, spawn_point)

# Spawns a player in the scene
func spawn_player(peer_id: int, character_class: String, scene_name: String, spawn_point: String, use_last_position: bool = false):
	print("SpawnManager: Spawning player with peer_id: ", peer_id)
	
	# Create a new instance of the scene
	var instance_key = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager").create_instance(scene_name)
	if instance_key != "":
		var scene_instance = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager").instances[instance_key]["scene_instance"]

		# Determine the spawn position
		var spawn_position = get_spawn_position(peer_id, scene_instance, spawn_point, use_last_position)
		
		# Load the player's character scene based on the class
		var character_scene_path = GlobalManager.GlobalSceneManager.scene_config.get_scene_path(character_class)
		var player_scene = load(character_scene_path)
		if player_scene and player_scene is PackedScene:
			var player_character = player_scene.instantiate()
			scene_instance.add_child(player_character)
			player_character.global_position = spawn_position
			print("Player spawned at position: ", spawn_position)
			
			# Add to the Movement Manager logic
			var player_movement_manager = GlobalManager.GlobalNodeManager.get_cached_node("game_manager", "player_movement_manager")
			player_movement_manager.add_player(peer_id, player_character)
		else:
			print("Error: Failed to load player character for class: ", character_class)
	else:
		print("Error: Failed to create instance for scene_name: ", scene_name)

# Updates the last known position of a player
func update_last_known_position(peer_id: int, position: Vector2):
	last_known_positions[peer_id] = position

# Clears the last known position of a player (e.g., on logout)
func clear_last_known_position(peer_id: int):
	if last_known_positions.has(peer_id):
		last_known_positions.erase(peer_id)
