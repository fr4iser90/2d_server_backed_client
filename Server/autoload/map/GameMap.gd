# res://src/core/autoload/map/GameMap.gd
extends Node


var game_manager = {
	"player_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager", "cache": true},
	"character_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager", "cache": true},
	"player_movement_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager", "cache": true},
}

var world_manager = {
	"instance_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager", "cache": true},
	"trigger_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager", "cache": true},
	"chunk_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager", "cache": true},
	"spawn_point_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/SpawnPointManager", "cache": true},
	"world_loader": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager", "cache": true},
	"entity_node_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/EntityNodeManager", "cache": true},
	"navigation_mesh_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager", "cache": true},
}

var inventory_manager = {
	
}

var quest_manager = {
	
}

func get_data() -> Dictionary:
	var all_data = {}

	# Get the list of properties (variablenochmlqas) in the current script
	var properties = get_property_list()

	# Iterate through the properties and add any Dictionary-type variables to all_data
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)

		# Ensure that only Dictionary-type variables are added
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = property_value

	return all_data


