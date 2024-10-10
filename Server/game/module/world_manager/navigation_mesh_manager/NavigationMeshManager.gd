# NavigationMeshManager.gd
extends Node

@onready var navigation_mesh_manager = $"."

@onready var navigation_mesh_pathfinding_handler = $Handler/NavigationMeshPathfindingHandler
@onready var navigation_mesh_obstacle_handler = $Handler/NavigationMeshObstacleHandler
@onready var navigation_mesh_instance_handler = $Handler/NavigationMeshInstanceHandler
@onready var navigation_mesh_update_handler = $Handler/NavigationMeshUpdateHandler
@onready var navigation_mesh_mob_handler = $Handler/NavigationMeshMobHandler
@onready var navigation_mesh_npc_handler = $Handler/NavigationMeshNPCHandler
@onready var navigation_mesh_baking_handler = $Handler/NavigationMeshBakingHandler
@onready var navigation_mesh_loading_handler = $Handler/NavigationMeshLoadingHandler
@onready var navigation_mesh_boundary_handler = $Handler/NavigationMeshBoundaryHandler
@onready var navigation_mesh_sync_handler = $Handler/NavigationMeshSyncHandler


var loaded_navmeshes = {}  # Stores loaded navigation meshes
var max_loaded_navmeshes = 50  # Max number of loaded navigation meshes at once
var preload_distance = 2  # Distance around player for preloading meshes

var instance_manager
var player_movement_manager
var is_initialized = false

# Initialize NavigationMeshManager
func initialize():
	if is_initialized:
		return
	instance_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "instance_manager")
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_player_module", "player_movement_manager")
	print("Initializing NavigationMeshManager with preloading distance: ", preload_distance)
	navigation_mesh_pathfinding_handler.initialize(self)
	navigation_mesh_obstacle_handler.initialize(self)
	navigation_mesh_instance_handler.initialize(self)
	navigation_mesh_update_handler.initialize(self)
	navigation_mesh_mob_handler.initialize(self)
	navigation_mesh_npc_handler.initialize(self)
	navigation_mesh_baking_handler.initialize(self)
	navigation_mesh_loading_handler.initialize(self)
	navigation_mesh_boundary_handler.initialize(self)
	navigation_mesh_sync_handler.initialize(self)
	is_initialized = true
	
## Load a navigation mesh for the specific area
#func load_navmesh(area_id: String): # Load the navigation mesh by its area ID.
	#return navmesh_loading_handler.load_navmesh(area_id)
#
## Preload navigation meshes around a player's position
#func preload_navmeshes_around_position(position: Vector2): # Preload navigation meshes around a player's position.
	#return navmesh_loading_handler.preload_navmeshes_around_position(position)
#
## Unload distant navigation meshes that are not in use
#func unload_distant_navmeshes(peer_id: int, current_position: Vector2): # Unload navmeshes far from the player.
	#return navmesh_loading_handler.unload_distant_navmeshes(peer_id, current_position)
#
## Handle pathfinding for a player or NPC
#func handle_pathfinding(start_position: Vector2, end_position: Vector2) -> PoolVector2Array: # Calculate the path from start to end.
	#return pathfinding_handler.calculate_path(start_position, end_position)
#
## Validate the movement of a player within the navigation mesh
#func validate_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool: # Validate player movement inside the navmesh.
	#return movement_validation_handler.validate_movement(peer_id, new_position, velocity)
#
## Handle dynamic obstacles and recalculate paths if necessary
#func handle_dynamic_obstacles(): # Recalculate paths when new obstacles are added.
	#return dynamic_update_handler.handle_dynamic_obstacles()
#
## Sync navigation data across clients for a specific player
#func sync_navigation_data(peer_id: int, navmesh_data: Dictionary): # Synchronize navmesh data across clients.
	#return sync_handler.sync_navigation_data(peer_id, navmesh_data)
#
## Handle AI navigation for NPCs and mobs
#func handle_ai_navigation(start_position: Vector2, end_position: Vector2, ai_behavior: String): # Handle AI pathfinding based on behavior.
	#return ai_navigation_handler.handle_ai_navigation(start_position, end_position, ai_behavior)
#
## Trigger events within a navigation mesh (e.g., collision with dynamic objects)
#func trigger_navmesh_event(navmesh_id: String, event_data: Dictionary): # Trigger a specific event in a navmesh.
	#return dynamic_update_handler.trigger_navmesh_event(navmesh_id, event_data)
#
## Preload critical navigation meshes for essential areas (e.g., dungeons, cities)
#func preload_critical_navmeshes(navmesh_list: Array): # Preload critical navigation meshes.
	#return navmesh_loading_handler.preload_critical_navmeshes(navmesh_list)
#
## Monitor performance of navigation meshes to optimize loading
#func monitor_navmesh_performance(navmesh_id: String): # Monitor a navmesh's performance for optimization.
	#return dynamic_update_handler.monitor_navmesh_performance(navmesh_id)
#
## Broadcast events to players in a specific navigation area
#func broadcast_event_to_players_in_navmesh(navmesh_id: String, event_data: Dictionary): # Broadcast event data to players within a navmesh.
	#return sync_handler.broadcast_event_to_players_in_navmesh(navmesh_id, event_data)
#
## Clean up unloaded navigation meshes to free memory
#func clean_up_navmeshes(): # Clean up navmeshes that are no longer in use.
	#return navmesh_loading_handler.clean_up_navmeshes()
#
## Print the memory usage of all loaded navigation meshes (for debugging)
#func print_navmesh_memory_usage(): # Debug function to print the memory usage of loaded navmeshes.
	#return dynamic_update_handler.print_navmesh_memory_usage()
#
## Update navigation meshes based on player movement and interaction
#func update_navmeshes_for_player(peer_id: int, position: Vector2): # Update the loaded navmeshes based on the player's new position.
	#return dynamic_update_handler.update_navmeshes_for_player(peer_id, position)
#
## Lock a navigation mesh for editing (prevents updates)
#func lock_navmesh_for_editing(navmesh_id: String): # Lock a navmesh to avoid changes during editing.
	#return navmesh_loading_handler.lock_navmesh_for_editing(navmesh_id)
#
## Unlock a navigation mesh after editing is complete
#func unlock_navmesh_after_editing(navmesh_id: String): # Unlock a navmesh after editing is complete.
	#return navmesh_loading_handler.unlock_navmesh_after_editing(navmesh_id)
