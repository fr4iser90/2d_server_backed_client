# res://src/game/player_manager/player_movement_manager/network_handler/movement_player_sync_handler.gd
extends Node

var instance_manager = null
var enet_client_manager = null
var packet_converter_handler = null
var packet_validation_handler = null

var last_known_position = {}
var last_known_velocity = {}

var is_initialized = false

# Initialize the handler and instance manager
func initialize():
	if is_initialized:
		return
	is_initialized = true
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	packet_converter_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_converter_handler")
	packet_validation_handler = GlobalManager.NodeManager.get_cached_node("packet_handler", "packet_validation_handler")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	print("MovementPlayerSyncHandler initialized.")

# Client-side: handle_packet in movement_player_sync_handler.gd
# Handle incoming movement data
func handle_packet(data: Dictionary):
	if data.has("players_movement_data"):
		print("data from movement_player_sync_handler : ", data)
		var players_movement_data = data["players_movement_data"]
		for peer_id in players_movement_data.keys():
			if int(peer_id) == enet_client_manager.get_peer_id():
				continue  # Skip self-update

			var movement_data = players_movement_data[peer_id]
			if packet_validation_handler.validate_movement_data(movement_data):
				var position = packet_converter_handler.convert_to_vector2(movement_data["position"])
				var velocity = packet_converter_handler.convert_to_vector2(movement_data["velocity"])

				if last_known_position.get(peer_id, Vector2()) != position or last_known_velocity.get(peer_id, Vector2()) != velocity:
					last_known_position[peer_id] = position
					last_known_velocity[peer_id] = velocity

				var instance_key = instance_manager.get_instance_id_for_peer(int(peer_id))
				if instance_manager:
					instance_manager.handle_entity_movement(instance_key, "players", int(peer_id), position, velocity)
				else:
					print("Error: InstanceManager not found!")
			else:
				print("Invalid movement data for peer_id:", peer_id)
