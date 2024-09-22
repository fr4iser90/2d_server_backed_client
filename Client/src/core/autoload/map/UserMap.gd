# res://src/core/autoload/map/UserMap.gd
extends Node

var user_manager = {
	"user_session_manager": {"path_tree": "/root/User/Manager/UserSessionManager", "cache": true},
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

