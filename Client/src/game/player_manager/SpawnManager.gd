# res://src/game/player_manager/SpawnManager.gd (Client)
extends Node

var is_initialized = false
var character_manager = null
var player_manager = null

# Initialize the manager if needed
func initialize():
	if is_initialized:
		return
	is_initialized = true
	player_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "player_manager")
	character_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "character_manager")
	
# Main function to handle player spawning
func spawn_player(character_data: Dictionary):
	print(character_data)
	var spawn_point = character_data.get("spawn_point", "")
	var last_known_position = character_data.get("last_known_position", Vector2(0, 0))
	
	# Decide whether to spawn at a specific spawn point or at the last known position
	if spawn_point != "":
		spawn_at_point(spawn_point)
	elif last_known_position != Vector2(0, 0):
		spawn_player_at_position(last_known_position)
	else:
		spawn_at_default_point()

# Spawn player at a specific spawn point
func spawn_at_point(spawn_point: String):
	print("Spawning player at spawn point: ", spawn_point)
	var player_scene = _get_player_scene()  # Get the player scene based on character class
	if player_scene:
		var player_node = player_scene.instantiate()
		# Use a predefined spawn point in the scene (replace with your logic for finding the spawn point)
		var spawn_position = _get_spawn_point_position(spawn_point)
		if spawn_position != null:
			player_node.global_position = spawn_position

		var client_main = get_node("/root/ClientMain")  # Use ClientMain instead of current_scene
		if client_main:
			client_main.add_child(player_node)
			print("Player spawned at spawn point: ", spawn_point)
		else:
			print("Error: ClientMain node not ready. Retrying.")
			call_deferred("spawn_at_point", spawn_point)  # Retry if scene is not ready
	else:
		print("Error: Could not load player scene.")

# Spawn player at a specific position
func spawn_player_at_position(position: Vector2):
	print("Spawning player at position: ", position)
	var player_scene = _get_player_scene()  # Get the player scene based on character class
	if player_scene:
		var player_node = player_scene.instantiate()
		player_node.global_position = position

		var client_main = get_node("/root/ClientMain")
		if client_main:
			client_main.add_child(player_node)
			print("Player spawned at position: ", position)
		else:
			print("Error: ClientMain node not ready.")
	else:
		print("Error: Could not load player scene.")

# Spawn player at the default point
func spawn_at_default_point():
	print("Spawning player at the default point")
	var player_scene = _get_player_scene()  # Get the player scene based on character class
	if player_scene:
		var player_node = player_scene.instantiate()
		player_node.global_position = get_default_spawn_position()

		var client_main = get_node("/root/ClientMain")
		if client_main:
			client_main.add_child(player_node)
			print("Player spawned at the default point")
		else:
			print("Error: ClientMain node not ready.")
	else:
		print("Error: Could not load player scene.")

# Retrieve the correct player scene based on character data
func _get_player_scene() -> PackedScene:
	var character_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "character_manager")
	var character_data = character_manager.get_selected_character_data()
	#print(character_data)
	var character_class = character_data.get("character_class", "")
	print(character_class)
	var scene_path = GlobalManager.SceneManager.get_scene_path(character_class)
	if scene_path == "":
		print("Error: No scene path found for character class: ", character_class)
		return null
	return load(scene_path)


# Retrieve the spawn point position in the current scene
func _get_spawn_point_position(spawn_point_name: String) -> Vector2:
	# Find the spawn point within ClientMain
	var client_main = get_node("/root/ClientMain")
	if client_main:
		var spawn_points_parent = client_main.get_node("SpawnRoom/SpawnPoints")
		if spawn_points_parent:
			var spawn_point_node = spawn_points_parent.get_node(spawn_point_name)
			if spawn_point_node:
				return spawn_point_node.global_position
			else:
				print("Error: Spawn point not found: ", spawn_point_name)
				return get_default_spawn_position()
		else:
			print("Error: SpawnPoints parent node not found.")
			return get_default_spawn_position()
	else:
		print("Error: ClientMain not ready.")
		return get_default_spawn_position()

# Default spawn point position
func get_default_spawn_position() -> Vector2:
	# Define the default spawn position
	return Vector2(100, 100)  # Replace with your actual default spawn position
