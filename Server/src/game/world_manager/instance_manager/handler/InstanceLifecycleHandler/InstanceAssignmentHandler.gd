# InstanceAssignmentHandler
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"

func assign_player_to_instance(peer_id: int, character_data: Dictionary) -> String:
	var scene_name = character_data.get("scene_name", "")
	if scene_name == "":
		print("Error: No scene name found in character data.")
		return ""

	var instance_key = instance_cache_handler.get_available_instance(scene_name)
	if instance_key == "":
		instance_key = instance_cache_handler.create_instance(scene_name)
	
	instance_cache_handler.add_player_to_instance(instance_key, {
		"peer_id": peer_id,
		"character_data": character_data
	})

	return instance_key
