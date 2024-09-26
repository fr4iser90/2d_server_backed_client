# InstanceLifecycleHandler
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"
@onready var instance_creation_handler = $"../InstanceCreationHandler"
@onready var instance_destruction_handler = $"../InstanceDestructionHandler"
@onready var movement_player_sync_handler = $"../../../../Player/PlayerMovementManager/NetworkHandler/MovementPlayerSyncHandler"


func remove_player_from_instance(peer_id: int):
	print("Removing player ", peer_id, " from instance")
	instance_destruction_handler.remove_player_from_instance(peer_id)

	# Ensure player movement data is cleaned up
	if movement_player_sync_handler:
		movement_player_sync_handler.cleanup_player_data(peer_id)



func create_instance(scene_name: String) -> String:
	return instance_creation_handler.create_instance(scene_name)
