extends Node

# Remove player from an instance
func remove_player_from_instance(peer_id: int):
	var instance_key = GlobalManager.InstanceManager.player_instance_map.get(peer_id, "")
	if instance_key != "":
		var instance = GlobalManager.InstanceManager.get_instance_data(instance_key)
		instance["players"].erase(peer_id)
		GlobalManager.InstanceManager.player_instance_map.erase(peer_id)
		print("Player removed from instance: ", instance_key)
	else:
		print("Error: No instance found for peer_id: ", peer_id)
