# InstancePlayerCharacterHandler
extends Node

@onready var instance_assignment_handler = $"../InstanceAssignmentHandler"

var player_movement_manager
var spawn_manager
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	spawn_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "spawn_manager")

# Handles player selection and assigns them to an instance
func handle_player_character_selected(peer_id: int, character_data: Dictionary) -> String:
	if not is_initialized:
		initialize()
	print("Handling character selection for peer_id: ", peer_id)
	
	# Assign player to an instance
	var instance_key = instance_assignment_handler.assign_player_to_instance(peer_id, character_data)
	
	if instance_key != "":
		print("Instance assigned to peer_id: ", peer_id, " with instance_key: ", instance_key)
		
		# Fetch spawn points for the scene (via SceneManager)
		var spawn_points = GlobalManager.SceneManager.get_spawn_points_for_scene(instance_key.split(":")[0])  # Szene aus dem Instanzschlüssel
		
		print("spawn_points: ", spawn_points)
		# Register spawn points in SpawnManager
		spawn_manager.register_spawn_points(instance_key, spawn_points)
		
		# Get a specific spawn point for this player
		var spawn_point = spawn_manager.get_spawn_point_position(instance_key, "default_spawn_point")  # Beispiel-Spawnpunktname
		
		# Add player to the PlayerMovementManager and place at spawn point
		if player_movement_manager:
			player_movement_manager.add_player(peer_id, character_data, spawn_point)
			print("Player added to Movement Manager at spawn point: ", spawn_point)
		else:
			print("Error: PlayerMovementManager not available.")
		
		return instance_key  # Return the assigned instance key
	else:
		print("Error: No instance assigned to player.")
		return ""  # Return empty string if no instance was assigned
