# res://src/core/autoload/map/CoreMap.gd
extends Node

var server_manager = {
	"player_visual_monitor": {"path_tree": "/root/Core/ServerManager/PlayerVisualMonitor", "cache": true},
	"player_movmemnt_data_monitor": {"path_tree": "/root/Core/ServerManager/PlayerMovementData", "cache": true},
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



