# res://src/core/game_manager/handlers/MobMovementHandler.gd
extends Node

var entity_node_manager = null
var is_initialized = false

# Initialize the handler
func initialize():
	if not is_initialized:
		entity_node_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceEntityNodeManager")
		is_initialized = true
		print("MobMovementHandler initialized.")

# Handle mob movement updates
func handle_movement_update(mob_id: int, position: Vector2, velocity: Vector2):
	if not entity_node_manager.entity_nodes.has(mob_id):
		print("Creating missing mob entity node for ID:", mob_id)
		var mob_data = { "mob_type": "GenericMob", "last_known_position": position }
		entity_node_manager.create_entity_node("mobs", mob_id, { "mob_data": mob_data })

	# Update the mob's position
	entity_node_manager.update_entity_position(mob_id, position, velocity)
