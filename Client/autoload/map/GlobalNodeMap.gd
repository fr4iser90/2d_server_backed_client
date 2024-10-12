extends Node

var UserSessionModule = {
	"UserSessionManager": {
		"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager",
		"cache": true
	},
}

var UserSessionManager = {
	"SessionLockHandler": {
		"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler/SessionLockHandler",
		"cache": true
	},
	"TimeoutHandler": {
		"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler/TimeoutHandler",
		"cache": true
	},
	"SessionLockTypeHandler": {
		"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler/SessionLockTypeHandler",
		"cache": true
	},
}

var GamePlayerModule = {
	"PlayerManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager",
		"cache": true
	},
	"CharacterManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager",
		"cache": true
	},
	"PlayerMovementManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager",
		"cache": true
	},
	"SpawnManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/SpawnManager",
		"cache": true
	},
	"PlayerStateMachineManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateMachineManager",
		"cache": true
	},
}

var PlayerManager = {
}

var CharacterManager = {
}

var PlayerMovementManager = {
}

var PlayerStateMachineManager = {
}

var GameWorldModule = {
	"InstanceManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager",
		"cache": true
	},
	"SceneTransitionManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/SceneTransitionManager",
		"cache": true
	},
}

var InstanceManager = {
	"InstanceEntityNodeManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceEntityNodeManager",
		"cache": true
	},
	"InstancePlayerMovementHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstancePlayerMovementHandler",
		"cache": true
	},
	"InstanceNPCMovementHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceNPCMovementHandler",
		"cache": true
	},
	"InstanceMobMovementHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceMobMovementHandler",
		"cache": true
	},
}

var SceneTransitionManager = {
	"Handler3": {
		"path_tree": "/root/Game/GameWorldModule/Manager/SceneTransitionManager/Handler/Handler3",
		"cache": true
	},
}

var GameLevelModule = {
}

var NetworkGameModule = {
	"NetworkClientServerManager": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkClientServerManager",
		"cache": true
	},
	"NetworkENetClientManager": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetClientManager",
		"cache": true
	},
	"NetworkChannelManager": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager",
		"cache": true
	},
	"NetworkPacketManager": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager",
		"cache": true
	},
}

var NetworkChannelManager = {
	"ChannelMap": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager/Handler/ChannelMap",
		"cache": true
	},
}

var NetworkPacketManager = {
	"PacketDispatchHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketDispatchHandler",
		"cache": true
	},
	"PacketProcessingHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketProcessingHandler",
		"cache": true
	},
	"PacketCreationHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketCreationHandler",
		"cache": true
	},
	"PacketHashHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketHashHandler",
		"cache": true
	},
	"PacketCacheHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketCacheHandler",
		"cache": true
	},
	"PacketConverterHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketConverterHandler",
		"cache": true
	},
	"PacketValidationHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketValidationHandler",
		"cache": true
	},
	"PacketProcessingUtil": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketProcessingUtil",
		"cache": true
	},
}

var NetworkGameModuleService = {
	"CoreHeartbeatService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/CoreHeartbeatService",
		"cache": true
	},
	"CoreConnectionService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/CoreConnectionService",
		"cache": true
	},
	"CoreDisconnectionService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/CoreDisconnectionService",
		"cache": true
	},
	"DataService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/DataService",
		"cache": true
	},
	"ChatMessageService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/ChatMessageService",
		"cache": true
	},
	"PlayerStatusUpdateService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/PlayerStatusUpdateService",
		"cache": true
	},
	"EventTriggeredService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/EventTriggeredService",
		"cache": true
	},
	"SpecialActionService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/SpecialActionService",
		"cache": true
	},
	"SelfTestChannelsService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Core/SelfTestChannelsService",
		"cache": true
	},
	"UserLoginService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/User/UserLoginService",
		"cache": true
	},
	"CharacterFetchService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Character/CharacterFetchService",
		"cache": true
	},
	"CharacterSelectService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Character/CharacterSelectService",
		"cache": true
	},
	"MovementPlayerService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Movement/MovementPlayerService",
		"cache": true
	},
	"MovementPlayerSyncService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Movement/MovementPlayerSyncService",
		"cache": true
	},
	"SceneInstanceDataService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/Scene/SceneInstanceDataService",
		"cache": true
	},
}


func get_all_data() -> Dictionary:
	var all_data = {}
	for node in get_tree().get_nodes_in_group("data_nodes"):
		all_data[node.name] = node.get_data()
	return all_data

func get_data() -> Dictionary:
	var all_data = {}
	var properties = get_property_list()
		
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)
			
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = flatten_nested_map(property_value)
		
	return all_data

func flatten_nested_map(nested_map: Dictionary) -> Dictionary:
	var flat_map = {}
		
	for key in nested_map.keys():
		var value = nested_map[key]
		
		if typeof(value) == TYPE_DICTIONARY and value.has('children'):
			flat_map[key] = value
			flat_map[key]['children'] = flatten_nested_map(value['children'])
		else:
			flat_map[key] = value
	
	return flat_map

