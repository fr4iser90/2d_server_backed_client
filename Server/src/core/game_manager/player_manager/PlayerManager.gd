# res://src/core/network/game_manager/player_manager/player_manager.gd
extends Node

var spawn_manager
var user_session_manager
var instance_manager 
var player_movement_manager

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	instance_manager = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager")
	spawn_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "spawn_manager")
	user_session_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "user_session_manager")
	player_movement_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "player_movement_manager")
	is_initialized = true


# Handle player spawn logic (delegated to SpawnManager)
func handle_player_spawn(peer_id: int, character_data: Dictionary):
	var scene_name = character_data.get("scene_name", "")
	var spawn_point = character_data.get("spawn_point", "")
	var character_class = character_data.get("character_class", "")
	var spawn_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "spawn_manager")
	if scene_name != "" and spawn_point != "" and character_class != "":
		spawn_manager.spawn_player(peer_id, character_class, scene_name, spawn_point, false)
	else:
		print("Error: Missing character data for spawning.")

func handle_player_logout(peer_id: int):
	spawn_manager.clear_last_known_position(peer_id)
	print("Player logged out, last known position cleared.")
