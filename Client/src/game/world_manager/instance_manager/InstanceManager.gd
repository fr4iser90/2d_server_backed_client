# GameInstanceManager.gd (Client)
extends Node

var instances = {}  # Stores instances and their associated entities (players, mobs, NPCs)

@onready var instance_player_movement_handler = $Handler/InstancePlayerMovementHandler
@onready var instance_npc_movement_handler = $Handler/InstanceNPCMovementHandler
@onready var instance_mob_movement_handler = $Handler/InstanceMobMovementHandler
@onready var instance_entity_node_manager = $Handler/InstanceEntityNodeManager

var is_initialized = false

# Initialize instance manager
func initialize():
	if not instance_entity_node_manager:
		instance_entity_node_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceEntityNodeManager")
	print("GameInstanceManager initialized.")

# Handle movement updates for players
func handle_player_movement(peer_id: int, position: Vector2, velocity: Vector2):
	instance_player_movement_handler.handle_movement_update(peer_id, position, velocity)

# Handle movement updates for NPCs
func handle_npc_movement(npc_id: int, position: Vector2, velocity: Vector2):
	instance_npc_movement_handler.handle_movement_update(npc_id, position, velocity)

# Handle movement updates for mobs
func handle_mob_movement(mob_id: int, position: Vector2, velocity: Vector2):
	instance_mob_movement_handler.handle_movement_update(mob_id, position, velocity)

# Handle entity movement updates, ensuring the entity exists or is created if it doesn't
func handle_entity_movement(entity_type: String, entity_id: int, position: Vector2, velocity: Vector2):
	# Check if the entity exists
	if not instance_entity_node_manager.entity_nodes.has(entity_id):
		print("Entity node for entity_id", entity_id, "is missing. Requesting necessary data for creation.")
		# Request character data from the server or check if data is available locally
		# Here, you would trigger a request to create the entity, but we skip this for simplicity.
		print("No character data available to create entity node. Skipping movement update for now.")
		return
	
	# If the entity exists, update its position
	update_entity_position(entity_type, entity_id, position, velocity)

# Update entity position
func update_entity_position(entity_type: String, entity_id: int, position: Vector2, velocity: Vector2):
	instance_entity_node_manager.update_entity_position(entity_id, position, velocity)

# Remove an entity from an instance
func remove_entity_from_instance(entity_type: String, entity_id: int):
	instance_entity_node_manager.remove_entity_node(entity_id)
