# res://src/core/autoload/map/GameMap.gd
extends Node


var player_manager = {
	"spawn_manager": {"path_tree": "/root/Game/Player/SpawnManager", "cache": true},
	"player_manager": {"path_tree": "/root/Game/Player/PlayerManager", "cache": true},
	"player_movement_manager": {"path_tree": "/root/Game/Player/PlayerMovementManager", "cache": true},
	"character_manager": {"path_tree": "/root/Game/Player/CharacterManager", "cache": true},
	"player_state_machine_manager": {"path_tree": "/root/Game/Player/PlayerStateMachineManager", "cache": true},
}

var world_manager = {
	"instance_manager": {"path_tree": "/root/Game/World/InstanceManager", "cache": true},
	"world_loader": {"path_tree": "/root/Game/World/InstanceManager", "cache": true},
	"instance_entity_node_manager": {"path_tree": "/root/Game/World/InstanceManager/Handler/InstanceEntityNodeManager", "cache": true},
}

var inventory_manager = {
	
}

var quest_manager = {
	
}

func get_data() -> Dictionary:
	var all_data = {}

	# Get the list of properties (variables) in the current script
	var properties = get_property_list()

	# Iterate through the properties and add any Dictionary-type variables to all_data
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)

		# Ensure that only Dictionary-type variables are added
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = property_value

	return all_data


