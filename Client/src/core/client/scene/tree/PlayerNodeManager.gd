# PlayerNodeManager.gd
extends Node

var player_nodes = {}

func create_player_node(peer_id: int, player_data: Dictionary):
	var character_data = player_data.get("character_data", {})
	
	if not character_data.has("scene_name"):
		print("Error: Scene name missing in player data")
		return
	
	var player_scene_path = GlobalManager.SceneManager.get_scene_path(character_data["scene_name"])
	var player_scene = load(player_scene_path)

	if player_scene and player_scene is PackedScene:
		var player_node = player_scene.instantiate()

		# Set player position
		var position = _convert_to_vector2(character_data.get("last_known_position", {}))
		if player_node is CharacterBody2D:
			player_node.global_position = position
		else:
			player_node.position = position

		# Add the player node to the scene
		get_tree().root.add_child(player_node)
		player_nodes[peer_id] = player_node
		print("Created player node for peer_id: ", peer_id)
	else:
		print("Failed to create player node for peer_id: ", peer_id)

# Update player position when new movement data is received
func update_player_position(peer_id: int, position: Vector2, velocity: Vector2):
	if player_nodes.has(peer_id):
		var player_node = player_nodes[peer_id]
		if player_node is CharacterBody2D:
			player_node.global_position = position
		else:
			player_node.position = position
		print("Updated player position for peer_id: ", peer_id)
	else:
		print("No player node found for peer_id: ", peer_id)

# Helper to convert incoming data to Vector2
func _convert_to_vector2(data: Dictionary) -> Vector2:
	if data.has("x") and data.has("y"):
		return Vector2(data["x"], data["y"])
	else:
		return Vector2.ZERO
