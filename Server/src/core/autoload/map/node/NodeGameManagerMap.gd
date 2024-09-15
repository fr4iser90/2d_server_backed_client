# res://src/core/autoload/map/node/NodeGameManagerMap.gd
extends Node


var game_manager = {
	"player_manager": {"path_tree": "/root/Game/Player/PlayerManager", "cache": true},
	"character_manager": {"path_tree": "/root/Game/Player/CharacterManager", "cache": true},
	"spawn_manager": {"path_tree": "/root/Game/Player/SpawnManager", "cache": true},
	"player_movement_manager": {"path_tree": "/root/Game/Player/PlayerMovementManager", "cache": true},
	"player_visual_monitor": {"path_tree": "/root/Core/ServerManager/PlayerVisualMonitor", "cache": true},
	"player_movmemnt_data_monitor": {"path_tree": "/root/Core/ServerManager/PlayerMovementData", "cache": true},
}

var world_manager = {
	"instance_manager": {"path_tree": "/root/Game/World/InstanceManager", "cache": true},
	"world_loader": {"path_tree": "/root/Game/World/InstanceManager", "cache": true},
}

var player_manager = {
	
}

var combat_manager = {
	
}
