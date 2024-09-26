# res://src/core/game_manager/handlers/NPCMovementHandler.gd
extends Node

var entity_node_manager = null
var is_initialized = false

# Initialize the handler
func initialize():
	if not is_initialized:
		entity_node_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "entity_node_manager")
		is_initialized = true
		print("NPCMovementHandler initialized.")

# Handle NPC movement updates
func handle_movement_update(npc_id: int, position: Vector2, velocity: Vector2):
	if not entity_node_manager.entity_nodes.has(npc_id):
		print("Creating missing NPC entity node for ID:", npc_id)
		var npc_data = { "npc_type": "GenericNPC", "last_known_position": position }
		entity_node_manager.create_entity_node("npcs", npc_id, { "npc_data": npc_data })

	# Update the NPC's position
	entity_node_manager.update_entity_position(npc_id, position, velocity)
