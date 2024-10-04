# res://src/game/player_manager/spawn_manager/SpawnManger.gd (Server)

extends Node

# Stores the spawn points for each scene/instance
var spawn_points = {}

# Register spawn points for a specific instance/scene
func register_spawn_points(instance_key: String, spawn_point_data: Dictionary):
	if not spawn_point_data.has("player_spawn_points"):
		print("Error: No player spawn points found for instance: ", instance_key)
		return
	
	# Speichern der Player-Spawnpunkte
	spawn_points[instance_key] = spawn_point_data["player_spawn_points"]
	print("Registered spawn points for instance_key: ", instance_key, spawn_point_data["player_spawn_points"])


# Get the position of a spawn point by name
func get_spawn_point_position(instance_key: String, spawn_point_name: String) -> Vector2:
	if spawn_points.has(instance_key):
		var instance_spawn_points = spawn_points[instance_key]
		if instance_spawn_points.has(spawn_point_name):
			return instance_spawn_points[spawn_point_name]
		else:
			print("Error: Spawn point not found: ", spawn_point_name)
	else:
		print("Error: No spawn points registered for instance: ", instance_key)
	
	return Vector2(-1, -1)  # Return invalid position if not found
