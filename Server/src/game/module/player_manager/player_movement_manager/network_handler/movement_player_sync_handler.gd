# res://src/core/network/manager/server_client_enet_packet_peer/handler/movement_player_sync_handler.gd (Server)
extends Node

var enet_server_manager
var instance_manager
var user_session_manager
var handler_name = "movement_player_sync_handler"

var last_sync_time = {}
var sync_interval = 0.01  # 50ms, for a 20 ticks per second update rate
var previous_positions = {}
var previous_velocities = {}

var is_initialized = false

# Initialization function to retrieve required managers
func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user", "user_session_manager")
	is_initialized = true

# Main function to sync movement with clients in the same instance
func sync_positions_with_clients_in_instance(peer_id: int, movement_data: Dictionary):
	if not is_initialized:
		print("Error: sync handler not initialized.")
		return

	# Ensure instance manager is present
	if instance_manager == null:
		print("Error: InstanceManager is not initialized.")
		return

	# Check if movement data should be broadcasted based on deltas
	if not _should_broadcast_movement(peer_id, movement_data):
		print("No significant movement change for peer_id ", peer_id)
		return

	# Retrieve the instance_key and instance data
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	if instance_key == "":
		print("Error: Instance key not found for peer_id: ", peer_id)
		return

	var instance = instance_manager.get_instance_data(instance_key)
	if not instance or not instance.has("players"):
		print("Error: Instance not found or no players in instance_key: ", instance_key)
		return

	# Broadcast movement data to other players in the instance
	_broadcast_movement_to_instance(peer_id, instance, movement_data)


# Check if movement should be broadcasted based on position and velocity changes
func _should_broadcast_movement(peer_id: int, movement_data: Dictionary) -> bool:
	var current_position = movement_data.get("position", Vector2.ZERO)
	var current_velocity = movement_data.get("velocity", Vector2.ZERO)

	var previous_position = previous_positions.get(peer_id, Vector2.ZERO)
	var previous_velocity = previous_velocities.get(peer_id, Vector2.ZERO)

	# If there are no significant changes, skip the broadcast
	if current_position == previous_position and current_velocity == previous_velocity:
		return false

	# Store the updated position and velocity
	previous_positions[peer_id] = current_position
	previous_velocities[peer_id] = current_velocity
	return true

# Broadcast movement data to all players in the same instance, excluding the sender
func _broadcast_movement_to_instance(peer_id: int, instance: Dictionary, movement_data: Dictionary):
	#print("Broadcasting movement data to instance: ", instance)
	var player_position = movement_data.get("position", Vector2.ZERO)
	var player_velocity = movement_data.get("velocity", Vector2.ZERO)
	instance_manager.update_player_position(peer_id, player_position, player_velocity)
	for player_data in instance["players"]:
		var target_peer_id = player_data["peer_id"]
		if target_peer_id == peer_id:
			continue  # Skip the sender's own data

		# Build and send movement packet
		var packet = _build_movement_packet(peer_id, movement_data)
		_send_packet_to_peer(target_peer_id, packet)
		#print("Sent movement data to peer: ", target_peer_id)


# Build movement data packet for a given peer_id
func _build_movement_packet(peer_id: int, movement_data: Dictionary) -> Dictionary:
	return {
		"players_movement_data": {
			peer_id: {
				"position": movement_data.get("position", Vector2.ZERO),
				"velocity": movement_data.get("velocity", Vector2.ZERO)
			}
		}
	}

# Send packet to a target peer
func _send_packet_to_peer(target_peer_id: int, packet: Dictionary):
	if enet_server_manager:
		enet_server_manager.send_packet(target_peer_id, handler_name, packet)
	else:
		print("Error: ENet server manager is not initialized.")

func cleanup_player_data(peer_id: int):
	print("Cleaning up data for peer_id: ", peer_id)
	
	# Remove from previous positions and velocities
	previous_positions.erase(peer_id)
	previous_velocities.erase(peer_id)

	# Remove from instance manager
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	if instance_key != "":
		var instance = instance_manager.get_instance_data(instance_key)
		if instance and instance.has("players"):
			instance["players"].erase(peer_id)
			print("Removed peer_id: ", peer_id, " from instance: ", instance_key)

	# Optionally remove from any other relevant systems (e.g., user sessions)
	if user_session_manager:
		user_session_manager.remove_user(peer_id)

	# Log the cleanup
	print("Completed cleanup for peer_id: ", peer_id)
	
func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected: ", peer_id)
	cleanup_player_data(peer_id)
