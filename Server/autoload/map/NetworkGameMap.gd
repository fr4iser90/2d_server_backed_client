# res://src/core/autoload/map/CoreMap.gd
extends Node

var network_game_module = {
	"network_server_client_manager": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkServerClientManager", "cache": true},
	"network_enet_server_manager": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager", "cache": true},
	"network_packet_manager": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager", "cache": true},
	"network_channel_manager": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager", "cache": true},
	"network_channel_map": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager/Map/ChannelMap", "cache": true},
}

var network_game_handler = {
	# Core
	"core_heartbeat_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreHeartbeatHandler ", "cache": true},
	"core_connection_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreConnectionHandler", "cache": true},
	"core_disconnection_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreDisconnectionHandler", "cache": true},
	"core_ping_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CorePingHandler", "cache": true},
	"core_server_status_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreServerStatusHandler", "cache": true},
	"core_error_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreErrorHandler", "cache": true},
	# User
	"user_login_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameUser/UserLoginHandler", "cache": true},
	"user_token_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameUser/UserTokenHandler", "cache": true},	
	# Movement
	"movement_player_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameMovement/MovementPlayerHandler", "cache": true},
	"movement_player_sync_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameMovement/MovementPlayerSyncHandler", "cache": true},
	# Instance 
	"scene_instance_data_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameInstance/SceneInstanceDataHandler", "cache": true},
	# Character
	"character_fetch_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter/CharacterFetchHandler", "cache": true},
	"character_select_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter/CharacterSelectHandler", "cache": true},
	"character_update_handler": {"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter/CharacterUpdateHandler", "cache": true},
	
}

var packet_manager_handler = {
	"packet_creation_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketCreationHandler", "cache": true},
	"packet_processing_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketProcessingHandler", "cache": true},
	"packet_dispatch_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketDispatchHandler", "cache": true},
	"packet_cache_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketCacheHandler", "cache": true},
	"packet_hash_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketHashHandler", "cache": true},
	"packet_converter_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketConverterHandler", "cache": true},
	"packet_validation_handler": {"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketValidationHandler", "cache": true},
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



