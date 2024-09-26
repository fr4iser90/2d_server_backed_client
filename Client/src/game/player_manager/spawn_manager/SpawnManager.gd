# SpawnManager
extends Node

var player_node = null
@onready var player_state_machine_manager = $"../PlayerStateMachineManager"

var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true

# Spawn the local player at a specific point or last known position
func spawn_local_player(character_data: Dictionary) -> Node:
	var spawn_point = character_data.get("spawn_point", "")
	var position = character_data.get("position", Vector2(0, 0))
		# Check if the player is already spawned to prevent multiple spawns
	if player_node:
		print("Player is already spawned, skipping spawn.")
		return player_node  # Return the existing player node
		
	if spawn_point != "":
		player_node = _spawn_at_point(spawn_point, character_data)
#	elif position != Vector2(0, 0):
#		player_node = _spawn_at_position(position, character_data)
	else:
		player_node = _spawn_at_default_point(character_data)

	# Set up local-specific features like input handling, camera, etc.
	_initialize_player_state_machine(player_node)
	return player_node

# Spawn at a specific point
func _spawn_at_point(spawn_point: String, character_data: Dictionary) -> Node:
	var player_scene = _get_player_scene(character_data.get("character_class", ""))
	var spawn_position = _get_spawn_point_position(spawn_point)
	return _add_player_node_to_scene(player_scene, spawn_position)

# Spawn at a specific position
func _spawn_at_position(position: Vector2, character_data: Dictionary) -> Node:
	var player_scene = _get_player_scene(character_data.get("character_class", ""))
	return _add_player_node_to_scene(player_scene, position)

# Default spawn point
func _spawn_at_default_point(character_data: Dictionary) -> Node:
	var player_scene = _get_player_scene(character_data.get("character_class", ""))
	return _add_player_node_to_scene(player_scene, Vector2(100, 100))  # Default position

# Utility function to add the player node to the scene
func _add_player_node_to_scene(player_scene: PackedScene, position: Vector2) -> Node:
	if player_scene:
		var player_node = player_scene.instantiate()
		player_node.global_position = position
		var client_main = get_node("/root/ClientMain")
		if client_main:
			client_main.add_child(player_node)
		else:
			print("Error: ClientMain node not found.")
		return player_node
	return null

# Retrieve player scene based on character class
func _get_player_scene(character_class: String) -> PackedScene:
	# Fetch scene path from the GlobalManager SceneManager
	var scene_path = GlobalManager.SceneManager.get_scene_path(character_class)
	if scene_path == "":
		print("Error: No scene path found for character class: ", character_class)
		return null
	return load(scene_path)

# Retrieve the spawn point position in the current scene
func _get_spawn_point_position(spawn_point_name: String) -> Vector2:
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
	return Vector2(100, 100)

# Initialize the player's state machine after spawning
func _initialize_player_state_machine(player_node: Node):
	player_state_machine_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "player_state_machine_manager")
	if player_state_machine_manager:
		player_state_machine_manager.set_player(player_node, true)  # 'true' for local player
		player_state_machine_manager.initialize_state("movement")
		print("PlayerStateMachineManager initialized for local player.")
		
		# Add Camera2D for the local player
		_attach_camera_to_player(player_node)
	else:
		print("Error: PlayerStateMachineManager not found.")

# Attach a Camera2D to the local player
func _attach_camera_to_player(player_node: Node):
	var camera = Camera2D.new()
	player_node.add_child(camera)  # Attach the camera to the player node
	camera.make_current()  # Set this as the active camera
	
	print("Camera2D attached to the local player.")
