# InstancePlayerCharacterHandler
extends Node

@onready var instance_assignment_handler = $"../InstanceAssignmentHandler"

var player_movement_manager
var spawn_point_manager
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "PlayerMovementManager")
	spawn_point_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "SpawnPointManager")

# Handles player selection and assigns them to an instance
func handle_player_character_selected(peer_id: int, character_data: Dictionary) -> String:
	if not is_initialized:
		initialize()
	print("Handling character selection for peer_id: ", peer_id, " | With following CharacterData: ", character_data)
	
	# Assign player to an instance
	var instance_key = instance_assignment_handler.assign_player_to_instance(peer_id, character_data)
	
	if instance_key != "":
		print("Instance assigned to peer_id: ", peer_id, " with instance_key: ", instance_key)
		
		# Fetch spawn points for the scene (via SceneManager)
		var spawn_points = GlobalManager.SceneManager.get_spawn_points_for_scene(instance_key.split(":")[0])
		
		print("spawn_points: ", spawn_points)
		print("character_data: ", character_data)
		
		var current_position = character_data["current_position"]
		# Ensure that current_position is a Vector2 or convert it if it's a string
		if typeof(current_position) == TYPE_STRING:
			# Parse the string into a Vector2, assuming the format is "(x, y)"
			current_position = current_position.trim_prefix("(").trim_suffix(")")
			var parsed_position = current_position.split(",")
			if parsed_position.size() == 2:
				current_position = Vector2(float(parsed_position[0]), float(parsed_position[1]))
			else:
				print("Error: Unable to parse current_position string into Vector2.")
				current_position = Vector2()  # Set a default position if parsing fails
		elif typeof(current_position) == TYPE_VECTOR2:
			# Use the current position directly if it's already a Vector2
			current_position = current_position
		else:
			print("Error: Unsupported type for current_position. Expected Vector2 or String.")

		# Register spawn points in SpawnManager
		spawn_point_manager.register_spawn_points(instance_key, spawn_points)
		
		# Get a specific spawn point for this player
		var spawn_point = spawn_point_manager.get_spawn_point_position(instance_key, "default_spawn_point")
		print("spawn_point :", spawn_point)
		print("current_position :", current_position)
		
		# Add player to the PlayerMovementManager and place at the parsed position
		if player_movement_manager:
			player_movement_manager.add_player(peer_id, character_data, current_position)
		else:
			print("Error: PlayerMovementManager not available.")
		
		return instance_key  # Return the assigned instance key
	else:
		print("Error: No instance assigned to player.")
		return ""  # Return empty string if no instance was assigned
