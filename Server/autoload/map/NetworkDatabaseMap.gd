# res://src/core/autoload/map/CoreMap.gd
extends Node


var network_database_module = {
	"network_server_database_manager": {"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkServerDatabaseManager", "cache": true},
	"network_middleware_manager": {"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkMiddlewareManager", "cache": true},
	"network_endpoint_manager": {"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkEndpointManager", "cache": true},
}

var network_database_handler = {
	"database_server_auth_handler": {"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseServer/DatabaseServerAuthHandler", "cache": true},
	"database_user_login_handler": {"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseUser/DatabaseUserLoginHandler", "cache": true},
	"database_user_token_handler": {"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseUser/DatabaseUserTokenHandler", "cache": true},
	"database_character_fetch_handler": {"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter/DatabaseCharacterFetchHandler", "cache": true},
	"database_character_select_handler": {"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter/DatabaseCharacterSelectHandler", "cache": true},
	"database_character_update_handler": {"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter/DatabaseCharacterUpdateHandler", "cache": true},
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



