# InstanceDestructionHandler
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"

# Called when a peer disconnects
func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)
	remove_player_from_instance(peer_id)

# Remove a player from an instance
func remove_player_from_instance(peer_id: int):
	print("Attempting to remove peer_id: ", peer_id)
	var instance_key = instance_cache_handler.get_instance_id_for_peer(peer_id)
	if instance_key == "":
		print("Error: No instance found for peer_id: ", peer_id)
		return
	
	print("Found instance_key: ", instance_key, " for peer_id: ", peer_id)

	# Retrieve the instance data
	var instance_data = instance_cache_handler.get_instance_data(instance_key)
	if instance_data and instance_data.has("players"):
		# Log the current players in the instance before removal
		print("Current players in instance: ", instance_key, " = ", instance_data["players"])

		# Find and remove the player by index
		var player_index = -1
		for i in range(instance_data["players"].size()):
			if instance_data["players"][i]["peer_id"] == peer_id:
				player_index = i
				break
		
		if player_index != -1:
			instance_data["players"].remove_at(player_index)
			print("Player ", peer_id, " removed from instance ", instance_key)
		else:
			print("Warning: Player ", peer_id, " not found in instance: ", instance_key)
		
		# Log the updated players in the instance
		print("Updated players in instance: ", instance_key, " = ", instance_data["players"])
	else:
		print("Error: No valid instance data found for instance_key: ", instance_key)

	# Remove player from player_instance_map
	if instance_cache_handler.player_instance_map.has(peer_id):
		instance_cache_handler.player_instance_map.erase(peer_id)
		print("Player ", peer_id, " removed from player_instance_map.")
	else:
		print("Warning: Player ", peer_id, " not found in player_instance_map.")

	# Log the current state of the instance cache and player_instance_map for verification
	print("Final instance_data for instance_key: ", instance_key, " = ", instance_data)
	print("Final player_instance_map: ", instance_cache_handler.player_instance_map)
