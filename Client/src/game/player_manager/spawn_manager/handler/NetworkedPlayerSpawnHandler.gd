extends Node

var networked_players = {}

# Spawn a networked player based on received character data
func spawn_networked_player(character_data: Dictionary) -> Node:
	var spawn_point = character_data.get("spawn_point", "")
	var position = character_data.get("position", Vector2(0, 0))
	var player_node = null
	
	if spawn_point != "":
		player_node = _spawn_at_point(spawn_point)
	elif position != Vector2(0, 0):
		player_node = _spawn_at_position(position)
	else:
		player_node = _spawn_at_default_point()

	# Store the networked player for future reference
	networked_players[character_data["peer_id"]] = player_node
	return player_node

# Similar spawn point and utility functions as in LocalPlayerSpawnHandler
func _spawn_at_point(spawn_point: String) -> Node:
	# Load the player scene based on character data, add to scene
	return _add_player_node_to_scene(_get_player_scene(), _get_spawn_point_position(spawn_point))

func _spawn_at_position(position: Vector2) -> Node:
	return _add_player_node_to_scene(_get_player_scene(), position)

func _spawn_at_default_point() -> Node:
	return _add_player_node_to_scene(_get_player_scene(), Vector2(100, 100))

# Utility function to add the networked player to the scene
func _add_player_node_to_scene(player_scene: PackedScene, position: Vector2) -> Node:
	if player_scene:
		var player_node = player_scene.instantiate()
		player_node.global_position = position
		var client_main = get_node("/root/ClientMain")
		client_main.add_child(player_node)
		return player_node
	return null

# Retrieve player scene for networked players (similar to LocalPlayerSpawnHandler)
func _get_player_scene() -> PackedScene:
	# Logic to load networked player scene
	return load("res://path_to_networked_player_scene.tscn")

# Retrieve the spawn point position in the current scene
func _get_spawn_point_position(spawn_point_name: String) -> Vector2:
	# Find the spawn point within ClientMain or the current scene structure
	var client_main = get_node("/root/ClientMain")
	if client_main:
		# Assuming spawn points are stored under a specific parent node in the scene, like "SpawnPoints"
		var spawn_points_parent = client_main.get_node("SpawnRoom/SpawnPoints")  # Adjust this path as necessary
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
	# Define the default spawn position if no specific spawn point is found
	return Vector2(100, 100)  # Replace this with your actual default spawn position

