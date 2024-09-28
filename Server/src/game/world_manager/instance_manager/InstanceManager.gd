# InstanceManager
extends Node

@onready var instance_lifecycle_handler = $Handler/InstanceLifecycleHandler
@onready var instance_cache_handler = $Handler/InstanceCacheHandler
@onready var instance_assignment_handler = $Handler/InstanceAssignmentHandler
@onready var instance_entity_manager = $Handler/InstanceEntityManager
@onready var instance_scene_manager = $Handler/InstanceSceneManager
@onready var instance_player_character_handler = $Handler/InstancePlayerCharacterHandler

signal instance_created(instance_key: String)
signal instance_assigned(peer_id: int, instance_key: String)

var max_players_per_instance = 20

var is_initialized = false

# Initialize the InstanceManager
func initialize():
	if is_initialized:
		return
	is_initialized = true

func get_max_players_per_instance() -> int:
	return max_players_per_instance
	
# Handles player selection and assigns them to an instance
func handle_player_character_selected(peer_id: int, character_data: Dictionary):
	return instance_player_character_handler.handle_player_character_selected(peer_id, character_data)
		
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
	return instance_cache_handler.get_minimal_player_data(instance_key)
