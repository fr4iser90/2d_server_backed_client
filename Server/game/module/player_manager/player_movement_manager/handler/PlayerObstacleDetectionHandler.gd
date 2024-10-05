# PlayerMovementObstacleDetectionHandler.gd
extends Node

func initialize(parent: Node):
	print("Initializing PlayerMovementObstacleDetectionHandler")

# Detect if there are obstacles near the player
func detect_obstacles(new_position: Vector2) -> bool:
	var space_state = get_tree().root.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = new_position
	var result = space_state.intersect_point(query)
	return result.size() > 0  # Return true if any obstacle is found
