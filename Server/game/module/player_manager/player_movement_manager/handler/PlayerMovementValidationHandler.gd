# PlayerMovementValidationHandler.gd
extends Node

func initialize(parent: Node):
	print("Initializing PlayerMovementValidationHandler")

# Checks if the player's movement is valid by avoiding obstacles and staying within the navigation region
func is_valid_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool:
	# Get the current 2D space state for collision detection
	var space_state = get_tree().root.get_world_2d().direct_space_state

	# Create the query parameters to check the point
	var query = PhysicsPointQueryParameters2D.new()
	query.position = new_position

	# Perform the query to detect any collisions/obstacles at the point
	var nearby_obstacles = space_state.intersect_point(query)

	# Loop through the results to see if any obstacle is found
	for result in nearby_obstacles:
		if result.collider is NavigationObstacle2D:
			print("Invalid movement! Obstacle detected at: ", result.position)
			return false  # Movement is blocked by an obstacle

	# Add additional checks if necessary (like staying within the navigation region)
	return true  # No obstacles detected, valid movement
