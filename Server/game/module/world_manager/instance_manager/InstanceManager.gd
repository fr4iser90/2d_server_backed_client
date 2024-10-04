# InstanceManager
extends Node

@onready var instance_lifecycle_handler = $Handler/InstanceLifecycleHandler
@onready var instance_cache_handler = $Handler/InstanceCacheHandler
@onready var instance_assignment_handler = $Handler/InstanceAssignmentHandler
@onready var instance_entity_manager = $Handler/InstanceEntityManager
@onready var instance_scene_manager = $Handler/InstanceSceneManager
@onready var instance_player_character_handler = $Handler/InstancePlayerCharacterHandler
@onready var instance_npc_handler = $Handler/InstanceNPCHandler
@onready var instance_mob_handler = $Handler/InstanceMobHandler
@onready var instance_state_handler = $Handler/InstanceStateHandler
@onready var instance_event_handler = $Handler/InstanceEventHandler

			
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

func update_player_position(peer_id: int, position: Vector2, velocity: Vector2):
	return instance_cache_handler.update_player_position(peer_id, position, velocity)

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

## Lock an instance for editing
#func lock_instance_for_editing(instance_key: String):
	#return instance_state_handler.lock_instance_for_editing(instance_key)
#
## Unlock an instance after editing
#func unlock_instance_after_editing(instance_key: String):
	#return instance_state_handler.unlock_instance_after_editing(instance_key)
#
## Broadcast an event to all players in an instance
#func broadcast_event_to_players_in_instance(instance_key: String, event_data: Dictionary):
	#return instance_event_handler.broadcast_event_to_players_in_instance(instance_key, event_data)
#
## Trigger an event within a specific instance
#func trigger_instance_event(instance_key: String, event_data: Dictionary):
	#return instance_event_handler.trigger_instance_event(instance_key, event_data)
#
## Preload critical instances immediately
#func preload_critical_instances(instance_list: Array):
	#return instance_cache_handler.preload_critical_instances(instance_list)
#
## Sync instance data across clients
#func sync_instance_data_across_clients(peer_id: int, instance_data: Dictionary):
	#return instance_cache_handler.sync_instance_data_across_clients(peer_id, instance_data)
#
## Save instance data to disk
#func save_instance_data(instance_key: String):
	#return instance_cache_handler.save_instance_data(instance_key)
#
## Load instance data from disk
#func load_instance_data(instance_key: String):
	#return instance_cache_handler.load_instance_data(instance_key)
#
## Pause updates for a specific instance
#func pause_instance(instance_key: String):
	#return instance_state_handler.pause_instance(instance_key)
#
## Resume updates after pausing
#func resume_instance(instance_key: String):
	#return instance_state_handler.resume_instance(instance_key)
#
## Handle when a player exits an instance
#func on_player_exit_instance(peer_id: int, instance_key: String):
	#return instance_lifecycle_handler.on_player_exit_instance(peer_id, instance_key)
#
## Handle when a player enters an instance
#func on_player_enter_instance(peer_id: int, instance_key: String):
	#return instance_lifecycle_handler.on_player_enter_instance(peer_id, instance_key)
#
## Perform a global cleanup of instances
#func perform_global_instance_cleanup():
	#return instance_cache_handler.perform_global_instance_cleanup()
#
## Print memory usage of all loaded instances
#func print_instance_memory_usage():
	#return instance_cache_handler.print_instance_memory_usage()
#
## Monitor instance performance for optimization
#func monitor_instance_performance(instance_key: String):
	#return instance_state_handler.monitor_instance_performance(instance_key)
#
## Simulate an event in an instance (for testing or debugging)
#func simulate_instance_event(instance_key: String, event_data: Dictionary):
	#return instance_event_handler.simulate_instance_event(instance_key, event_data)
#
## Add NPC to the instance
#func add_npc_to_instance(instance_key: String, npc_data: Dictionary):
	#return instance_npc_handler.add_npc_to_instance(instance_key, npc_data)
#
## Remove NPC from the instance
#func remove_npc_from_instance(instance_key: String, npc_id: String):
	#return instance_npc_handler.remove_npc_from_instance(instance_key, npc_id)
#
## Update NPC position in the instance
#func update_npc_position(instance_key: String, npc_id: String, position: Vector2):
	#return instance_npc_handler.update_npc_position(instance_key, npc_id, position)
#
## Trigger NPC behavior in an instance
#func trigger_npc_behavior(instance_key: String, npc_id: String, behavior: String):
	#return instance_npc_handler.trigger_npc_behavior(instance_key, npc_id, behavior)
#
## Update instance state (active, paused, etc.)
#func update_instance_state(instance_key: String, state: String):
	#return instance_state_handler.update_instance_state(instance_key, state)
