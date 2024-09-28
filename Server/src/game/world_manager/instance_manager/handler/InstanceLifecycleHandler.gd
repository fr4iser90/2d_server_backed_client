# InstanceLifecycleHandler
extends Node

@onready var instance_cache_handler = $"../InstanceCacheHandler"
@onready var instance_creation_handler = $"../InstanceCreationHandler"
@onready var instance_destruction_handler = $"../InstanceDestructionHandler"


func remove_player_from_instance(peer_id: int):
	instance_destruction_handler.remove_player_from_instance(peer_id)

func create_instance(scene_name: String) -> String:
	return instance_creation_handler.create_instance(scene_name)
