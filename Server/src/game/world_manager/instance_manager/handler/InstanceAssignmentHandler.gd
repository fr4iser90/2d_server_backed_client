# InstanceAssignmentHandler
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"

# Assign player to an available instance or create a new one
func assign_player_to_instance(peer_id: int, character_data: Dictionary) -> String:
	# Determine the scene the player belongs to
	var scene_name = character_data.get("current_area", "")
	if scene_name == "":
		print("Error: No scene name found in character data.")
		return ""

	# Find or create an available instance
	var instance_key = instance_cache_handler.get_available_instance(scene_name)
	if instance_key == "":
		instance_key = instance_cache_handler.create_instance(scene_name)

	# Add player to the instance in both full and minimal data maps
	instance_cache_handler.add_player_to_instance(instance_key, {
		"peer_id": peer_id,
		"character_data": character_data
	})
	print("Player assigned to instance:", instance_key)
	return instance_key
