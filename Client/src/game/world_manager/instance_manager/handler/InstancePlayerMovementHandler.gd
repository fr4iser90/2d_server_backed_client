# res://src/game/world_manager/instance_manager/handler/InstancePlayerMovementHandler.gd
extends Node

var entity_node_manager = null
var is_initialized = false

# Initialize the handler
func initialize():
	if not is_initialized:
		entity_node_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceEntityNodeManager")
		is_initialized = true
		print("PlayerMovementHandler initialized.")

# Handle player movement updates
func handle_movement_update(peer_id: int, position: Vector2, velocity: Vector2):
	if not entity_node_manager.entity_nodes.has(peer_id):
		print("Creating missing player entity node for ID:", peer_id)
		var character_data = { "scene_name": "Knight", "position": position }
		entity_node_manager.create_entity_node("players", peer_id, { "character_data": character_data })

	# Update the entity's position
	entity_node_manager.update_entity_position(peer_id, position, velocity)
