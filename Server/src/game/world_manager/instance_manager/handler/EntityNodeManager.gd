# res://src/game/world_manager/EntityNodeManager.gd
extends Node

var entity_nodes = {}

# Create entity node (player, mob, NPC)
func create_entity_node(entity_type: String, entity_id: int, entity_data: Dictionary):
	var scene_path = GlobalManager.SceneManager.get_scene_path(entity_data.get("scene_name", ""))
	print("Creating entity node with the following data:", entity_data)
	var scene = load(scene_path)
	if scene and scene is PackedScene:
		var entity_node = scene.instantiate()
		var position = _convert_to_vector2(entity_data.get("last_known_position", {}))
		print("Setting position for entity ID:", entity_id, "at position:", position)
		
		# Check if the entity_node has a global_position property
		if entity_node is Node2D:
			entity_node.global_position = position
		else:
			print("Error: Entity node does not have global_position. It might not be a Node2D.")
		
		get_tree().root.add_child(entity_node)
		entity_nodes[entity_id] = entity_node
		print("Created entity node for ", entity_type, " with ID: ", entity_id)
	else:
		print("Failed to create entity node for entity ID:", entity_id)

# Remove entity node
func remove_entity_node(entity_id: int):
	if entity_nodes.has(entity_id):
		var entity_node = entity_nodes[entity_id]
		entity_node.queue_free()
		entity_nodes.erase(entity_id)
		print("Removed entity node for ID: ", entity_id)

# Helper: Convert to Vector2
func _convert_to_vector2(data: Dictionary) -> Vector2:
	if data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	return Vector2.ZERO
