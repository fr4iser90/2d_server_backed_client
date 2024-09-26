# GameInstanceManager.gd (Client)
extends Node

var instances = {}  # Stores instances and their associated entities (players, mobs, NPCs)


@onready var instance_player_movement_handler = $Handler/InstancePlayerMovementHandler
@onready var instance_npc_movement_handler = $Handler/InstanceNPCMovementHandler
@onready var instance_mob_movement_handler = $Handler/InstanceMobMovementHandler
@onready var instance_entity_node_manager = $Handler/InstanceEntityNodeManager

@onready var scene_instance_data_handler = $NetworkHandler/SceneInstanceDataHandler

var player_instance_map = {}
var is_initialized = false


# Initialize instance manager
func initialize():
	if not instance_entity_node_manager:
		instance_entity_node_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_entity_node_manager")
	scene_instance_data_handler.connect("entity_received", Callable(instance_entity_node_manager, "_on_entity_received"))
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
				instance_entity_node_manager.create_entity_node(entity_type, entity_id, entity_data)

# Handle movement updates, ensuring the entity exists or is created if it doesn't
func handle_entity_movement(instance_key: String, entity_type: String, entity_id: int, position: Vector2, velocity: Vector2):
	# Prüfen, ob die Entität existiert
	if not instance_entity_node_manager.entity_nodes.has(entity_id):
		print("Entity node for peer_id", entity_id, "is missing. Requesting necessary data for creation.")
		
		# Fordere die Character-Daten vom Server an oder überprüfe, ob diese Daten lokal verfügbar sind
		var entity_data = instances.get(instance_key, {}).get(entity_type, {})
		
		# Überprüfen, ob wir die notwendigen Character-Daten haben
		if entity_data.has("character_class"):
			# Wenn wir die Character-Daten haben, erstellen wir die Entität
			instance_entity_node_manager.create_entity_node(entity_type, entity_id, entity_data)
		else:
			print("No character data available to create entity node. Skipping movement update for now.")
			return  # Breche den Bewegungs-Update-Prozess ab, bis die Daten verfügbar sind
		
	# Führe das Positionsupdate nur durch, wenn die Entität existiert
	update_entity_position(entity_type, entity_id, position, velocity)



# Update entity position
func update_entity_position(entity_type: String, entity_id: int, position: Vector2, velocity: Vector2):
	return instance_entity_node_manager.update_entity_position(entity_id, position, velocity)

# Remove an entity from an instance
func remove_entity_from_instance(entity_type: String, entity_id: int):
	return instance_entity_node_manager.remove_entity_node(entity_id)

# Get the instance_key for a given peer_id
func get_instance_id_for_peer(peer_id: int) -> String:
	if player_instance_map.has(peer_id):
		return player_instance_map[peer_id]
	else:
		print("No instance found for peer_id: ", peer_id)
		return ""
