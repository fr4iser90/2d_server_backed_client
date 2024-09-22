# EntityManager.gd
extends Node

var entity_nodes = {}  # Stores nodes by entity ID and type (players, mobs, NPCs)
var is_initialized = false

# Initialize instance manager
func initialize():
	if is_initialized:
		print("EntityManager already initialized. Skipping initialization.")
		return
	is_initialized = true
	print("EntityManager initialized.")
	
# Create an entity node (generalized for players, mobs, and NPCs)
func create_entity_node(entity_type: String, entity_id: int, entity_data: Dictionary):
	print("Creating entity node for ", entity_type, " with ID: ", entity_id)
	
	# Debugging entity_data to ensure it's being received correctly
	print("Received entity data: ", entity_data)

	var scene_name = entity_data.get("scene_name", "")
	print("Scene name for entity: ", scene_name)
	
	var scene_path = GlobalManager.SceneManager.get_scene_path(scene_name)
	print("Resolved scene path: ", scene_path)

	var scene = load(scene_path)
	
	if scene and scene is PackedScene:
		var entity_node = scene.instantiate()
		var position = _convert_to_vector2(entity_data.get("last_known_position", {}))
		print("Setting position for entity ID: ", entity_id, " at position: ", position)
		entity_node.global_position = position
		get_tree().root.add_child(entity_node)
		entity_nodes[entity_id] = entity_node
		print("Successfully created entity node for ", entity_type, " with ID: ", entity_id)
	else:
		print("Error: Failed to load entity scene for ", entity_type, " with ID: ", entity_id, ". Scene path: ", scene_path)

# Update entity position
func update_entity_position(entity_id: int, position: Vector2, velocity: Vector2):
	print("Updating position for entity ID: ", entity_id, " to position: ", position, " with velocity: ", velocity)
	if entity_nodes.has(entity_id):
		var entity_node = entity_nodes[entity_id]
		entity_node.global_position = position
		print("Successfully updated position for entity ID: ", entity_id)
	else:
		print("Error: No entity found for ID: ", entity_id)

# Remove entity node
func remove_entity_node(entity_id: int):
	print("Removing entity node for ID: ", entity_id)
	if entity_nodes.has(entity_id):
		var entity_node = entity_nodes[entity_id]
		entity_node.queue_free()
		entity_nodes.erase(entity_id)
		print("Successfully removed entity node for ID: ", entity_id)
	else:
		print("Error: No entity found for ID: ", entity_id)

# Helper: Convert to Vector2
func _convert_to_vector2(data: Dictionary) -> Vector2:
	if data.has("x") and data.has("y"):
		print("Converting data to Vector2: ", data)
		return Vector2(data["x"], data["y"])
	else:
		print("Invalid data for Vector2 conversion. Returning Vector2.ZERO")
	return Vector2.ZERO
