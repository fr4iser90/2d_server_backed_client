# InstanceManager
extends Node

@onready var instance_lifecycle_handler = $Handler/InstanceLifecycleHandler
@onready var instance_cache_handler = $Handler/InstanceCacheHandler
@onready var instance_assignment_handler = $Handler/InstanceAssignmentHandler
@onready var instance_entity_manager = $Handler/InstanceEntityManager
@onready var instance_scene_manager = $Handler/InstanceSceneManager
@onready var scene_instance_data_handler = $NetworkHandler/SceneInstanceDataHandler
@onready var player_movement_manager = $"../../Player/PlayerMovementManager"

signal instance_created(instance_key: String)
signal instance_assigned(peer_id: int, instance_key: String)

var is_initialized = false

# Initialize the InstanceManager
func initialize():
	if is_initialized:
		return
	is_initialized = true

# Handles player selection and assigns them to an instance
func handle_player_character_selected(peer_id: int, character_data: Dictionary):
	print("InstanceManager: Handling character selection for peer_id: ", peer_id)
	
	# Assign player to an instance
	var instance_key = instance_assignment_handler.assign_player_to_instance(peer_id, character_data)
	
	if instance_key != "":
		print("Instance assigned to peer_id: ", peer_id, " with instance_key: ", instance_key)
		
		# Add player to the PlayerMovementManager after assignment
		if player_movement_manager:
			player_movement_manager.add_player(peer_id, character_data)
			print("Player added to Movement Manager: ", peer_id)
		else:
			print("Error: PlayerMovementManager not available.")
		
		emit_signal("instance_assigned", peer_id, instance_key)
		return instance_key  # Return the assigned instance key
	else:
		print("Error: No instance assigned to player.")
		return ""  # Return empty string if no instance was assigned
		
# Retrieve instance data by instance key
func get_instance_data(instance_key: String) -> Dictionary:
	return instance_cache_handler.get_instance_data(instance_key)

# Get instance ID for a given peer ID
func get_instance_id_for_peer(peer_id: int) -> String:
	return instance_cache_handler.get_instance_id_for_peer(peer_id)

# Remove a player from an instance
func remove_player_from_instance(peer_id: int):
	instance_lifecycle_handler.remove_player_from_instance(peer_id)

# Collect minimal data for players in the instance
func get_minimal_player_data(instance_key: String) -> Array:
	return instance_entity_manager.get_minimal_player_data(instance_key)
