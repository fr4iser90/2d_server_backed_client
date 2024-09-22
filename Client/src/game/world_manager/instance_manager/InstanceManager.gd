# GameInstanceManager.gd (Client)
extends Node

var instances = {}  # Stores instances and their associated entities (players, mobs, NPCs)
var entity_node_manager = null
var player_instance_map = {}
var is_initialized = false

# Initialize instance manager
func initialize():
	if not entity_node_manager:
		entity_node_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "entity_node_manager")
	print("GameInstanceManager initialized.")

# Handle player joining an instance
func handle_join_instance(instance_key: String, instance_data: Dictionary):
	print("Client joining instance: ", instance_key)
	create_instance_entities(instance_key, instance_data)

# Create entities in the instance (players, mobs, NPCs)
func create_instance_entities(instance_key: String, instance_data: Dictionary):
	instances[instance_key] = instance_data
	for entity_type in ["players", "mobs", "npcs"]:
		for entity_data in instance_data.get(entity_type, []):
			var entity_id = entity_data.get("peer_id", -1)
			if entity_id != -1:
				entity_node_manager.create_entity_node(entity_type, entity_id, entity_data)

# Handle movement updates, ensuring the entity exists or is created
func handle_entity_movement(entity_type: String, entity_id: int, position: Vector2, velocity: Vector2):
	# Ensure the entity exists
	if not entity_node_manager.entity_nodes.has(entity_id):
		print("Creating missing entity node for", entity_type, "with ID:", entity_id)
		var character_data = { "scene_name": "Knight", "last_known_position": position }
		entity_node_manager.create_entity_node(entity_type, entity_id, { "character_data": character_data })
	
	# Update the entity's position
	update_entity_position(entity_type, entity_id, position, velocity)

# Update entity position
func update_entity_position(entity_type: String, entity_id: int, position: Vector2, velocity: Vector2):
	entity_node_manager.update_entity_position(entity_id, position, velocity)

# Remove an entity from an instance
func remove_entity_from_instance(entity_type: String, entity_id: int):
	entity_node_manager.remove_entity_node(entity_id)

# Get the instance_key for a given peer_id
func get_instance_id_for_peer(peer_id: int) -> String:
	if player_instance_map.has(peer_id):
		return player_instance_map[peer_id]
	else:
		print("No instance found for peer_id: ", peer_id)
		return ""
