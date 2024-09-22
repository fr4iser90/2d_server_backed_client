# res://src/core/network/manager/server_client_enet_packet_peer/handler/movement_player_sync_handler.gd (Server)
extends Node

var enet_server_manager
var instance_manager
var handler_name = "movement_player_sync_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")  # Get instance manager node
	is_initialized = true

# Server-side: sync_positions_with_clients_in_instance
func sync_positions_with_clients_in_instance(peer_id: int, movement_data: Dictionary):
	if instance_manager == null:
		print("Error: InstanceManager is not initialized.")
		return

	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	var instance = instance_manager.instances.get(instance_key, null)

	if instance:
		# Prepare movement data for all players
		var players_movement_data = {}
		
		# Iterate over all players in the instance and collect their movement data
		for player_data in instance["players"]:
			var target_peer_id = player_data["peer_id"]
			
			# Ensure last_known_position and velocity exist in player_data
			var last_known_position = player_data.get("last_known_position", Vector2.ZERO)
			var velocity = player_data.get("velocity", Vector2.ZERO)

			#print("player_data: ", player_data)
			# Collect movement data for this player
			players_movement_data[target_peer_id] = {
				"position": last_known_position,
				"velocity": velocity
			}
			
			# Broadcast this movement data to all other clients in the instance
			if target_peer_id != peer_id:  # Avoid sending to the original sender
				var packet = {
					"players_movement_data": players_movement_data
				}
				enet_server_manager.send_packet(target_peer_id, handler_name, packet)
	else:
		print("Error: Instance not found for instance_key: ", instance_key)

