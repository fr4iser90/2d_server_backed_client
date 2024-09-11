extends Node

signal ready_to_initialize

var player_manager
var enet_server_manager

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_server_manager")
	is_initialized = true


