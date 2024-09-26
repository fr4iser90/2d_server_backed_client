# res://src/core/autoload/map/CoreMap.gd
extends Node

var network_handler = {
	"core_heartbeat_handler": {"path_tree": "/root/User/Manager/UserSessionManager/NetworkHandler/CoreHeartbeatHandler", "cache": true},
	"core_connection_handler": {"path_tree": "/root/User/Manager/UserSessionManager/NetworkHandler/CoreConnectionHandler", "cache": true},
	"core_disconnection_handler": {"path_tree": "/root/User/Manager/UserSessionManager/NetworkHandler/CoreDisconnectionHandler", "cache": true},
	"core_ping_handler": {"path_tree": "/root/Core/Network/Handler/Core/CorePingHandler", "cache": true},
	"core_server_status_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreServerStatusHandler", "cache": true},
	"core_error_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreErrorHandler", "cache": true},
	"movement_player_handler": {"path_tree": "/root/Game/Player/PlayerMovementManager/NetworkHandler/MovementPlayerHandler", "cache": true},
	"movement_player_sync_handler": {"path_tree": "/root/Game/Player/PlayerMovementManager/NetworkHandler/MovementPlayerSyncHandler", "cache": true},
	"scene_instance_data_handler": {"path_tree": "/root/Game/World/InstanceManager/NetworkHandler/SceneInstanceDataHandler", "cache": true},
	# Backend Handler
	"auth_login_handler": {"path_tree": "/root/Core/Network/Handler/Auth/AuthLoginHandler", "cache": true},
	"char_fetch_handler": {"path_tree": "/root/Game/Player/CharacterManager/NetworkHandler/CharFetchHandler", "cache": true},
	"char_select_handler": {"path_tree": "/root/Game/Player/CharacterManager/NetworkHandler/CharSelectHandler", "cache": true}
}

var packet_hander = {
	"packet_creation_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketCreationHandler", "cache": true},
	"packet_processing_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketProcessingHandler", "cache": true},
	"packet_dispatch_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketDispatchHandler", "cache": true},
	"packet_cache_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketCacheHandler", "cache": true},
	"packet_hash_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketHashHandler", "cache": true},
	"packet_converter_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketConverterHandler", "cache": true},
	"packet_validation_handler": {"path_tree": "/root/Core/Network/Manager/PacketManager/PacketValidationHandler", "cache": true},
}	

	
var backend_manager = {
	"backend_middleware_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager/Manager/BackendMiddlewareManager", "cache": true},
	"backend_routes_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager/Manager/BackendRoutesManager", "cache": true},
	"network_server_backend_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager", "cache": true},
	"auth_server_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager/Manager/AuthServerManager", "cache": true},
	"auth_token_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager/Manager/AuthTokenManager", "cache": true},
}

var auth_manager = {
	"auth_server_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager/Manager/AuthServerManager", "cache": true},
	"auth_token_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager/Manager/AuthTokenManager", "cache": true},
}

var network_meta_manager = {
	"network_manager": {"path_tree": "/root/Core/Network", "cache": true},
	"network_server_client_manager": {"path_tree": "/root/Core/Network/NetworkServerClientManager", "cache": true},
	"enet_server_manager": {"path_tree": "/root/Core/Network/Manager/ENetServerManager", "cache": true},
	"packet_manager": {"path_tree": "/root/Core/Network/Manager/PacketManager", "cache": true},
	"channel_manager": {"path_tree": "/root/Core/Network/Manager/ChannelManager", "cache": true},
	"channel_map": {"path_tree": "/root/Core/Network/Manager/ChannelManager/ChannelMap", "cache": true},
}

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



