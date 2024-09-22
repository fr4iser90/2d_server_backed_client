# scene_instance_data_handler (Server)
extends Node

var enet_server_manager
var instance_manager
var handler_name = "scene_instance_data_handler"
var is_initialized = false

# Initialize the handler
func initialize():
	if is_initialized:
		return
	print("Initializing scene_instance_data_handler...")
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")  # Get instance manager node
	is_initialized = true
	print("scene_instance_data_handler initialized.")

# Handle sending scene and instance data to a new player
func send_instance_data_to_client(peer_id: int):
	print("Preparing to send instance data to peer_id:", peer_id)
	
	# Get the instance_id for the peer_id
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	print("Instance key for peer_id", peer_id, ":", instance_key)

	if instance_key != "":
		# Fetch minimal instance data from InstanceManager
		var minimal_player_data = instance_manager.get_minimal_player_data(instance_key)
		var instance_data = instance_manager.get_instance_data(instance_key)
		print("Fetched minimal player data for instance key:", instance_key, ":", minimal_player_data)
		
		# Check if instance_data is valid
		if instance_data and instance_data.has("scene_path"):
			# Create a packet with the scene and minimal entity data
			var packet_data = {
				"scene_path": instance_data["scene_path"],
				"players": minimal_player_data,
				"mobs": instance_data["mobs"],
				"npcs": instance_data["npcs"]
			}

			# Send the data to the client
			print("Sending packet to peer_id:", peer_id, "with data:", packet_data)
			enet_server_manager.send_packet_to_peer(peer_id, handler_name, packet_data)
		else:
			print("Error: Invalid instance data for instance key:", instance_key)
	else:
		print("Error: No instance found for peer_id:", peer_id)
