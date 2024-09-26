extends Node

var player_instance_map = {}  # Maps peer_id to instance_key

# Handles player selection and assigns them to an instance
func handle_player_character_selected(peer_id: int, character_data: Dictionary) -> String:
	var scene_name = character_data.get("scene_name", "")
	if scene_name == "":
		return ""

	# Assign the player to an instance
	var instance_key = GlobalManager.InstanceManager.assign_player_to_instance(scene_name, {
		"peer_id": peer_id,
		"character_data": character_data
	})

	# Add player to movement manager
	add_player_to_movement_manager(peer_id, character_data)

	return instance_key

# Add player to PlayerMovementManager
func add_player_to_movement_manager(peer_id: int, player_data: Dictionary):
	var player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	if player_movement_manager:
		player_movement_manager.add_player(peer_id, player_data)
	else:
		print("Error: PlayerMovementManager not available.")
