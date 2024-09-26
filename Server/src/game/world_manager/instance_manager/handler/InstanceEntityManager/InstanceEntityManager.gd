# InstanceEntityManager
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"

func get_minimal_player_data(instance_key: String) -> Array:
	# Retrieve instance data from the cache handler
	var instance_data = instance_cache_handler.get_instance_data(instance_key)
	var minimal_data = []
	
	# Process player data from the instance
	for player_data in instance_data["players"]:
		minimal_data.append({
			"peer_id": player_data["peer_id"],
			"character_class": player_data["character_data"].get("character_class", "")
		})
	return minimal_data
