# InstanceDestructionHandler
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"

# Called when a peer disconnects
func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)
	instance_cache_handler.remove_player_from_instance(peer_id)

# Remove a player from an instance
func remove_player_from_instance(peer_id: int):
	print("Attempting to remove peer_id: ", peer_id)
	var instance_key = instance_cache_handler.get_instance_id_for_peer(peer_id)
	if instance_key == "":
		print("Error: No instance found for peer_id: ", peer_id)
		return
	
	print("Found instance_key: ", instance_key, " for peer_id: ", peer_id)

	# Remove player from full instance data
	var instance_data = instance_cache_handler.get_instance_data(instance_key)
	if instance_data and instance_data.has("players"):
		var player_index = -1
		for i in range(instance_data["players"].size()):
			if instance_data["players"][i]["peer_id"] == peer_id:
				player_index = i
				break
		
		if player_index != -1:
			instance_data["players"].remove_at(player_index)
			print("Player ", peer_id, " removed from full instance ", instance_key)
		else:
			print("Warning: Player ", peer_id, " not found in full instance: ", instance_key)
	else:
		print("Error: No valid full instance data found for instance_key: ", instance_key)

	# Remove player from minimal instance data
	var minimal_instance_data = instance_cache_handler.get_minimal_player_data(instance_key)
	var minimal_player_index = -1
	for i in range(minimal_instance_data.size()):
		if minimal_instance_data[i]["peer_id"] == peer_id:
			minimal_player_index = i
			break
	
	if minimal_player_index != -1:
		minimal_instance_data.remove_at(minimal_player_index)
		print("Player ", peer_id, " removed from minimal instance ", instance_key)
	else:
		print("Warning: Player ", peer_id, " not found in minimal instance: ", instance_key)

	# Remove player from player_instance_map
	if instance_cache_handler.player_instance_map.has(peer_id):
		instance_cache_handler.player_instance_map.erase(peer_id)
		print("Player ", peer_id, " removed from player_instance_map.")
	else:
		print("Warning: Player ", peer_id, " not found in player_instance_map.")

	# Log the current state of the instance cache and player_instance_map for verification
	print("Final instance_data for instance_key: ", instance_key, " = ", instance_data)
	print("Final minimal_instance_data for instance_key: ", instance_key, " = ", minimal_instance_data)
	print("Final player_instance_map: ", instance_cache_handler.player_instance_map)
