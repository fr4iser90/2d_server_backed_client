extends NavigationAgent2D

func _ready():
	print("NavigationAgent2D Ready")
	# Use Callable instead of passing a string
	connect("target_reached", Callable(self, "_on_target_reached"))
	connect("path_changed", Callable(self, "_on_path_changed"))
	connect("velocity_computed", Callable(self, "_on_velocity_computed"))

# When the agent computes its velocity for each step
func _on_velocity_computed(safe_velocity):
	print("Navigating... Current Velocity:", safe_velocity)

# When the agent reaches the destination
func _on_target_reached():
	print("Target reached!")

# When the path changes (useful for handling dynamic obstacles)
func _on_path_changed():
	print("Path has changed!")
	_on_path_blocked()

# Check if an obstacle is blocking the path
func _on_path_blocked():
	if is_obstacle_around():
		print("Obstacle detected! Path recalculated.")
	else:
		print("Path changed without obstacles.")

# A method to check if there's an obstacle in the way
func is_obstacle_around() -> bool:
	var space_state = get_tree().root.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	
	# Ensure you're using the correct position variable for your node
	query.position = self.global_position  # If this is a Node2D, 'global_position' works.
	query.max_results = 10
	
	var nearby_obstacles = space_state.intersect_point(query)
	
	for result in nearby_obstacles:
		if result.collider is NavigationObstacle2D:
			return true
	return false

