extends Node

var last_known_positions = {}
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true

# Spawns the player at a given position (Vector2)
func spawn_player_at_position(position: Vector2, character_type: String):
	print("Player spawned at position: ", position)
	var scene_path = get_character_scene_path(character_type)
	if scene_path == "":
		print("Error: Character scene path not found for type: ", character_type)
		return
	
	var character_scene = load(scene_path) as PackedScene
	if character_scene:
		var character_instance = character_scene.instantiate()
		add_child(character_instance)
		character_instance.position = position
	else:
		print("Error: Unable to load character scene from path: ", scene_path)


# Spawns the player at a given spawn point (name of the point, not a Vector2)
func spawn_player_at_spawnpoint(spawn_point_name: String, scene_name: String, character_type: String):
	print("Spawning player at spawn point: ", spawn_point_name)
	var spawn_point_node = GlobalManager.GlobalSceneManager.get_spawn_point(scene_name, spawn_point_name)
	spawn_player_at_position(spawn_point_node.global_position, character_type)

# Client-specific function to determine where to spawn the player
func get_spawn_position_from_server(character_data: Dictionary):
	var scene_name = character_data.scene_name
	var spawn_point_name = character_data.spawn_point
	var last_known_position = Vector2(character_data.last_known_position.x, character_data.last_known_position.y)
	var character_type = character_data.character_class.to_lower()  # or whatever key holds the character type

	if last_known_position != Vector2(0, 0):
		spawn_player_at_position(last_known_position, character_type)
	else:
		spawn_player_at_spawnpoint(spawn_point_name, scene_name, character_type)

# Gets the scene path for a character type
func get_character_scene_path(character_type: String) -> String:
	var scene_paths = {
		"mage": "res://shared/data/characters/players/mage/mage.tscn",
		"archer": "res://shared/data/characters/players/archer/archer.tscn",
		"knight": "res://shared/data/characters/players/knight/knight.tscn",
	}
	return scene_paths.get(character_type, "")
