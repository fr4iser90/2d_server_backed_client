# res://src/core/autoload/map/node/NodeGameManagerMap.gd
extends Node


var game_manager = {
	"player_manager": {"path_tree": "/root/Core/GameManager/PlayerManager", "cache": true},
	"character_manager": {"path_tree": "/root/Core/GameManager/CharacterManager", "cache": true},
	"spawn_manager": {"path_tree": "/root/Core/GameManager/SpawnManager", "cache": true},
	"player_movement_manager": {"path_tree": "/root/Core/GameManager/Movement2DManager", "cache": true},
	"player_visual_monitor": {"path_tree": "/root/Core/GameManager/PlayerVisualMonitor", "cache": true},
	"player_movmemnt_data_monitor": {"path_tree": "/root/Core/GameManager/PlayerMovementData", "cache": true},
}

var world_manager = {
	"instance_manager": {"path_tree": "/root/Core/WorldManager/InstanceManager", "cache": true},
	"world_loader": {"path_tree": "/root/Core/WorldManager/InstanceManager", "cache": true},
}
