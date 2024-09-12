# res://src/core/autoloads/node_manager/NodeConfigManager.gd
extends Node

# Adding cache flags to all nodes
var global_scene_manager = {
	"scene_cache_manager": {"name": "SceneCacheManager", "path_file": "res://src/core/autoloads/scene_manager/SceneCacheManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneCacheManager", "cache": true},
	"scene_loading_manager": {"name": "SceneLoadingManager", "path_file": "res://src/core/autoloads/scene_manager/SceneLoadingManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneLoadingManager", "cache": true},
	"scene_config_manager": {"name": "SceneConfig", "path_file": "res://src/core/autoloads/scene_manager/SceneConfigManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneConfigManager", "cache": true},
	"scene_overlay_manager": {"name": "SceneOverlayManager", "path_file": "res://src/core/autoloads/scene_manager/SceneOverlayManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneOverlayManager", "cache": true},
	"scene_audio_manager": {"name": "SceneAudioManager", "path_file": "res://src/core/autoloads/scene_manager/SceneAudioManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneAudioManager", "cache": true},
	"scene_event_manager": {"name": "SceneEventManager", "path_file": "res://src/core/autoloads/scene_manager/SceneEventManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneEventManger", "cache": true},
	"scene_physics_manager": {"name": "ScenePhysicsManager", "path_file": "res://src/core/autoloads/scene_manager/ScenePhysicsManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/ScenePhysicsManager", "cache": true},
	"scene_lighting_manager": {"name": "SceneLightingManager", "path_file": "res://src/core/autoloads/scene_manager/SceneLightingManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneLightningManager", "cache": true},
	"scene_transition_manager": {"name": "SceneTransitionManager", "path_file": "res://src/core/autoloads/scene_manager/SceneTransitionManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneTransitionManager", "cache": true},
	"scene_state_manager": {"name": "SceneStateManager", "path_file": "res://src/core/autoloads/scene_manager/SceneStateManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneStateManager", "cache": true},
	"spawn_manager": {"name": "SceneSpawnManager", "path_file": "res://src/core/autoloads/scene_manager/SceneSpawnManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneSpawnManager", "cache": true},
	"instance_manager": {"name": "SceneInstanceManager", "path_file": "res://src/core/autoloads/scene_manager/SceneInstanceManager.gd", "path_tree": "/root/GlobalManager/GlobalSceneManager/SceneInstanceManager", "cache": true},
}

var global_node_manager = {
	"node_cache_manager": {"name": "NodeCacheManager", "path_file": "res://src/core/autoloads/node_manager/NodeCacheManager.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeCacheManager", "cache": true},
	"node_state_manager": {"name": "NodeStateManager", "path_file": "res://src/core/autoloads/node_manager/NodeStateManager.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeStateManager", "cache": true},
	"node_life_cycle_manager": {"name": "NodeLifecycleManager", "path_file": "res://src/core/autoloads/node_manager/NodeLifecycleManager.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeLifecycleManager", "cache": true},
	"node_retrieval_manager": {"name": "NodeRetrievalManager", "path_file": "res://src/core/autoloads/node_manager/NodeRetrievalManager.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeRetrievalManager", "cache": true},
	"node_temporary_manager": {"name": "NodeTemporaryManager", "path_file": "res://src/core/autoloads/node_manager/TemporaryNodeManager.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeTemporaryManager", "cache": true},
	"node_config_manager": {"name": "NodeConfigManager", "path_file": "res://src/core/autoloads/node_manager/NodeConfigManager.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeConfigManager", "cache": true},
	"node_scanner": {"name": "NodeScanner", "path_file": "res://src/core/autoloads/node_manager/NodeScanner.gd", "path_tree": "/root/GlobalManager/GlobalNodeManager/NodeScanner", "cache": true},
}

var auth_manager = {
	"auth_server_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/AuthServerManager", "cache": true},
	"auth_token_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/AuthTokenManager", "cache": true}
}

var network_meta_manager = {
	"network_manager": {"path_tree": "/root/Core/NetworkManager", "cache": true},
	"enet_server_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/ENetServerManager", "cache": true},
	"packet_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/PacketManager", "cache": true},
	"channel_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/ChannelManager", "cache": true},
	"global_channel_map": {"path_tree": "/root/Core/NetworkManager/MetaManager/ChannelManager/GlobalChannelMap", "cache": true, "initialize": true},
	"user_session_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/UserSessionManager", "cache": true},
}

var backend_manager = {
	"backend_middleware_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/BackendMiddlewareManager", "cache": true},
	"backend_routes_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/BackendRoutesManager", "cache": true},
	"network_server_backend_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager", "cache": true},
}
var game_manager = {
	"player_manager": {"path_tree": "/root/Core/GameManager/PlayerManager", "cache": true},
	"character_manager": {"path_tree": "/root/Core/GameManager/CharacterManager", "cache": true},
	"spawn_manager": {"path_tree": "/root/Core/GameManager/SpawnManager", "cache": true},
	"player_movement_manager": {"path_tree": "/root/Core/GameManager/Movement2DManager", "cache": true},
	"player_visual_monitor": {"path_tree": "/root/Core/GameManager/PlayerVisualMonitor", "cache": true},
	"player_movmemnt_data_monitor": {"path_tree": "/root/Core/GameManager/PlayerMovementData", "cache": true},
}

var network_handler = {
	"heartbeat_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/HeartbeatHandler", "cache": true},
	"connection_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/ConnectionHandler", "cache": true},
	"disconnection_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/DisconnectionHandler", "cache": true},
	"data_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/DataHandler", "cache": true},
	"chat_messages_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/ChatMessageHandler", "cache": true},
	"player_status_update_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/PlayerStatusUpdateHandler", "cache": true},
	"event_triggered_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/EventTriggeredHandler", "cache": true},
	"special_action_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/SpecialActionHandler", "cache": true},
	"player_movement_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/PlayerMovementHandler", "cache": true},
	"player_movement_sync_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/PlayerMovementSyncHandler", "cache": true},
	# Backend Handler
	"backend_login_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Handler/BackendHandler/BackendLoginHandler", "cache": true},
	"backend_character_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Handler/BackendHandler/BackendCharacterHandler", "cache": true},
	"backend_character_select_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Handler/BackendHandler/BackendCharacterSelectHandler", "cache": true}
}

var basic_handler = {
	"heartbeat_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/HeartbeatHandler", "cache": true},
	"connection_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/ConnectionHandler", "cache": true},
	"disconnection_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/DisconnectionHandler", "cache": true},
	"data_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/DataHandler", "cache": true},
	"chat_messages_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/ChatMessageHandler", "cache": true},
	"player_status_update_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/PlayerStatusUpdateHandler", "cache": true},
	"event_triggered_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/EventTriggeredHandler", "cache": true},
	"special_action_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/SpecialActionHandler", "cache": true},
	"player_movement_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/PlayerMovementHandler", "cache": true},
	"player_movement_sync_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerClientManager/Handler/ClientServerHandler/PlayerMovementSyncHandler", "cache": true},
}

var backend_handler = {
	"backend_login_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Handler/BackendHandler/BackendLoginHandler", "cache": true},
	"backend_character_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Handler/BackendHandler/BackendCharacterHandler", "cache": true},
	"backend_character_select_handler": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Handler/BackendHandler/BackendCharacterSelectHandler", "cache": true}
}

var ui_handler = {
	# Add UI handlers here with paths and cache flags
}

var world_manager = {
	"instance_manager": {"path_tree": "/root/Core/WorldManager/InstanceManager", "cache": true},
	"world_loader": {"path_tree": "/root/Core/WorldManager/InstanceManager", "cache": true},
}

var combat_handler = {
	# Add combat handlers here with paths and cache flags
}

var quest_handler = {
	# Add quest handlers here with paths and cache flags
}

var misc_handler = {
	# Add miscellaneous handlers here with paths and cache flags
}

# Get node information (path and cache flag) based on the type and name
func get_node_info(node_type: String, node_name: String) -> Dictionary:
	var node_dict = null
	match node_type:
		"global_scene_manager":
			node_dict = global_scene_manager
		"global_node_manager":
			node_dict = global_scene_manager
		"network_meta_manager":
			node_dict = network_meta_manager
		"auth_manager":
			node_dict = auth_manager
		"game_manager":
			node_dict = game_manager
		"world_manager":
			node_dict = world_manager
		"backend_manager":
			node_dict = backend_manager
		"network_handler":
			node_dict = network_handler
		"basic_handler":
			node_dict = basic_handler
		"backend_handler":
			node_dict = backend_handler
		"ui_handler":
			node_dict = ui_handler
		"combat_handler":
			node_dict = combat_handler
		"quest_handler":
			node_dict = quest_handler
		"misc_handler":
			node_dict = misc_handler
		"handlers":
			node_dict = misc_handler
		_:
			print("Error: Invalid node type:", node_type)
			return {}

	if node_dict and node_dict.has(node_name):
		return node_dict[node_name]
	else:
		#print("Error: Node name not found in config:", node_name)
		return {}
