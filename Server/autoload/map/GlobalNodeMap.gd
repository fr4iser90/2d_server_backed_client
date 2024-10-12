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
	"PlayerMovementManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager",
		"cache": true
	},
	"PlayerMovementData": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementData",
		"cache": true
	},
	"PlayerVisualMonitor": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerVisualMonitor",
		"cache": true
	},
	"PlayerStateManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager",
		"cache": true
	},
	"CharacterManager": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager",
		"cache": true
	},
}

var PlayerManager = {
	"PlayerSpawnHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager/Handler/PlayerSpawnHandler",
		"cache": true
	},
}

var PlayerMovementManager = {
	"PlayerMovementValidationHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovementValidationHandler",
		"cache": true
	},
	"PlayerMovementPositionSyncHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovementPositionSyncHandler",
		"cache": true
	},
	"PlayerMovementObstacleDetectionHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovementObstacleDetectionHandler",
		"cache": true
	},
	"PlayerMovementTriggerHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovementTriggerHandler",
		"cache": true
	},
	"PlayerMovementUpdateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovementUpdateHandler",
		"cache": true
	},
	"PlayerMovementStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovementStateHandler",
		"cache": true
	},
	"PlayerMovmementProcessHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler/PlayerMovmementProcessHandler",
		"cache": true
	},
}

var PlayerMovementData = {
}

var PlayerVisualMonitor = {
}

var PlayerStateManager = {
	"PlayerIdleStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerIdleStateHandler",
		"cache": true
	},
	"PlayerMovingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerMovingStateHandler",
		"cache": true
	},
	"PlayerAttackingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerAttackingStateHandler",
		"cache": true
	},
	"PlayerCastingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerCastingStateHandler",
		"cache": true
	},
	"PlayerSwimmingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerSwimmingStateHandler",
		"cache": true
	},
	"PlayerClimbingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerClimbingStateHandler",
		"cache": true
	},
	"PlayerJumpingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerJumpingStateHandler",
		"cache": true
	},
	"PlayerDashingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerDashingStateHandler",
		"cache": true
	},
	"PlayerDodgingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerDodgingStateHandler",
		"cache": true
	},
	"PlayerStunnedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerStunnedStateHandler",
		"cache": true
	},
	"PlayerDeadStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerDeadStateHandler",
		"cache": true
	},
	"PlayerInteractingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerInteractingStateHandler",
		"cache": true
	},
	"PlayerBlockingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerBlockingStateHandler",
		"cache": true
	},
	"PlayerRidingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerRidingStateHandler",
		"cache": true
	},
	"PlayerStealthStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerStealthStateHandler",
		"cache": true
	},
	"PlayerHealingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerHealingStateHandler",
		"cache": true
	},
	"PlayerFallingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerFallingStateHandler",
		"cache": true
	},
	"PlayerFlyingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerFlyingStateHandler",
		"cache": true
	},
	"PlayerKnockedDownStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerKnockedDownStateHandler",
		"cache": true
	},
	"PlayerClimbingLadderStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerClimbingLadderStateHandler",
		"cache": true
	},
	"PlayerSlidingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerSlidingStateHandler",
		"cache": true
	},
	"PlayerCrouchingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerCrouchingStateHandler",
		"cache": true
	},
	"PlayerTradingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerTradingStateHandler",
		"cache": true
	},
	"PlayerUsingItemStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerUsingItemStateHandler",
		"cache": true
	},
	"PlayerAimingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerAimingStateHandler",
		"cache": true
	},
	"PlayerRespawningStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerRespawningStateHandler",
		"cache": true
	},
	"PlayerMountedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerMountedStateHandler",
		"cache": true
	},
	"PlayerTeleportingStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerTeleportingStateHandler",
		"cache": true
	},
	"PlayerDisarmedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerDisarmedStateHandler",
		"cache": true
	},
	"PlayerParalyzedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerParalyzedStateHandler",
		"cache": true
	},
	"PlayerKnockingBackStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerKnockingBackStateHandler",
		"cache": true
	},
	"PlayerDebuffedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerDebuffedStateHandler",
		"cache": true
	},
	"PlayerBuffedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerBuffedStateHandler",
		"cache": true
	},
	"PlayerInCombatStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerInCombatStateHandler",
		"cache": true
	},
	"PlayerEncumberedStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerEncumberedStateHandler",
		"cache": true
	},
	"PlayerFrozenStateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager/Handler/PlayerFrozenStateHandler",
		"cache": true
	},
}

var CharacterManager = {
	"CharacterUtilityHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager/Handler/CharacterUtilityHandler",
		"cache": true
	},
	"CharacterAddHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager/Handler/CharacterAddHandler",
		"cache": true
	},
	"CharacterSelectionHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager/Handler/CharacterSelectionHandler",
		"cache": true
	},
	"CharacterUpdateHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager/Handler/CharacterUpdateHandler",
		"cache": true
	},
	"CharacterRemoveHandler": {
		"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager/Handler/CharacterRemoveHandler",
		"cache": true
	},
}

var GameWorldModule = {
	"InstanceManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager",
		"cache": true
	},
	"ChunkManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager",
		"cache": true
	},
	"TriggerManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager",
		"cache": true
	},
	"SpawnPointManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/SpawnPointManager",
		"cache": true
	},
	"NavigationMeshManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager",
		"cache": true
	},
}

var InstanceManager = {
	"InstanceLifecycleHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceLifecycleHandler",
		"cache": true
	},
	"InstanceSceneManager": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceSceneManager",
		"cache": true
	},
	"InstanceCreationHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceCreationHandler",
		"cache": true
	},
	"InstanceCacheHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceCacheHandler",
		"cache": true
	},
	"InstanceAssignmentHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceAssignmentHandler",
		"cache": true
	},
	"InstanceDestructionHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceDestructionHandler",
		"cache": true
	},
	"InstanceBoundaryHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceBoundaryHandler",
		"cache": true
	},
	"InstanceLoaderHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceLoaderHandler",
		"cache": true
	},
	"InstancePlayerCharacterHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstancePlayerCharacterHandler",
		"cache": true
	},
	"InstanceUpdateHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceUpdateHandler",
		"cache": true
	},
	"InstanceCalculationHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceCalculationHandler",
		"cache": true
	},
	"InstanceNPCHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceNPCHandler",
		"cache": true
	},
	"InstanceMobHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceMobHandler",
		"cache": true
	},
	"InstanceStateHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceStateHandler",
		"cache": true
	},
	"InstanceEventHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceEventHandler",
		"cache": true
	},
}

var ChunkManager = {
	"ChunkCreationHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkCreationHandler",
		"cache": true
	},
	"ChunkCacheHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkCacheHandler",
		"cache": true
	},
	"ChunkAssignmentHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkAssignmentHandler",
		"cache": true
	},
	"ChunkDestructionHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkDestructionHandler",
		"cache": true
	},
	"ChunkBoundaryHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkBoundaryHandler",
		"cache": true
	},
	"ChunkEventHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkEventHandler",
		"cache": true
	},
	"ChunkUpdateHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkUpdateHandler",
		"cache": true
	},
	"ChunkCalculationHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkCalculationHandler",
		"cache": true
	},
	"ChunkTransitionHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkTransitionHandler",
		"cache": true
	},
	"ChunkStateHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkStateHandler",
		"cache": true
	},
}

var TriggerManager = {
	"TriggerInstanceChangeHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerInstanceChangeHandler",
		"cache": true
	},
	"TriggerZoneChangeHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerZoneChangeHandler",
		"cache": true
	},
	"TriggerRoomChangeHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerRoomChangeHandler",
		"cache": true
	},
	"TriggerEventHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerEventHandler",
		"cache": true
	},
	"TriggerTrapHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerTrapHandler",
		"cache": true
	},
	"TriggerObjectiveHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerObjectiveHandler",
		"cache": true
	},
	"TriggerArea2DCalculationHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerArea2DCalculationHandler",
		"cache": true
	},
}

var NavigationMeshManager = {
	"NavigationMeshPathfindingHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshPathfindingHandler",
		"cache": true
	},
	"NavigationMeshObstacleHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshObstacleHandler",
		"cache": true
	},
	"NavigationMeshInstanceHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshInstanceHandler",
		"cache": true
	},
	"NavigationMeshUpdateHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshUpdateHandler",
		"cache": true
	},
	"NavigationMeshMobHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshMobHandler",
		"cache": true
	},
	"NavigationMeshNPCHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshNPCHandler",
		"cache": true
	},
	"NavigationMeshBakingHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshBakingHandler",
		"cache": true
	},
	"NavigationMeshLoadingHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshLoadingHandler",
		"cache": true
	},
	"NavigationMeshBoundaryHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshBoundaryHandler",
		"cache": true
	},
	"NavigationMeshSyncHandler": {
		"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager/Handler/NavigationMeshSyncHandler",
		"cache": true
	},
}

var GameLevelModule = {
	"LevelManager": {
		"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager",
		"cache": true
	},
}

var LevelManager = {
	"LevelCreationHandler": {
		"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler/LevelCreationHandler",
		"cache": true
	},
	"LevelSaveHandler": {
		"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler/LevelSaveHandler",
		"cache": true
	},
	"LevelMapGenerator": {
		"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler/LevelMapGenerator",
		"cache": true
	},
}

var NetworkGameModule = {
	"NetworkServerClientManager": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkServerClientManager",
		"cache": true
	},
	"NetworkENetServerManager": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager",
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

var NetworkENetServerManager = {
	"ENetServerStartHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager/Handler/ENetServerStartHandler",
		"cache": true
	},
	"ENetServerStopHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager/Handler/ENetServerStopHandler",
		"cache": true
	},
	"ENetServerOnPeerConnectedHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager/Handler/ENetServerOnPeerConnectedHandler",
		"cache": true
	},
	"ENetServerOnPeerDisconnectedHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager/Handler/ENetServerOnPeerDisconnectedHandler",
		"cache": true
	},
	"ENetServerProcessHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager/Handler/ENetServerProcessHandler",
		"cache": true
	},
	"ENetServerPacketSendHandler": {
		"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager/Handler/ENetServerPacketSendHandler",
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
}

var NetworkGameModuleService = {
	"CoreHeartbeatService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCore/CoreHeartbeatService",
		"cache": true
	},
	"CoreConnectionService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCore/CoreConnectionService",
		"cache": true
	},
	"CoreDisconnectionService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCore/CoreDisconnectionService",
		"cache": true
	},
	"CorePingService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCore/CorePingService",
		"cache": true
	},
	"CoreServerStatusService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCore/CoreServerStatusService",
		"cache": true
	},
	"CoreErrorService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCore/CoreErrorService",
		"cache": true
	},
	"MovementPlayerService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameMovement/MovementPlayerService",
		"cache": true
	},
	"MovementPlayerSyncService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameMovement/MovementPlayerSyncService",
		"cache": true
	},
	"SceneInstanceDataService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameInstance/SceneInstanceDataService",
		"cache": true
	},
	"TriggerEntryService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerEntryService",
		"cache": true
	},
	"TriggerExitService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerExitService",
		"cache": true
	},
	"TriggerInstanceChangeService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerInstanceChangeService",
		"cache": true
	},
	"TriggerZoneChangeService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerZoneChangeService",
		"cache": true
	},
	"TriggerRoomChangeService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerRoomChangeService",
		"cache": true
	},
	"TriggerEventService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerEventService",
		"cache": true
	},
	"TriggerTrapService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerTrapService",
		"cache": true
	},
	"TriggerObjectiveService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameTrigger/TriggerObjectiveService",
		"cache": true
	},
	"UserLoginService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameUser/UserLoginService",
		"cache": true
	},
	"UserTokenService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameUser/UserTokenService",
		"cache": true
	},
	"CharacterFetchService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCharacter/CharacterFetchService",
		"cache": true
	},
	"CharacterSelectService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCharacter/CharacterSelectService",
		"cache": true
	},
	"CharacterUpdateService": {
		"path_tree": "/root/Network/NetworkGameModule/Service/GameCharacter/CharacterUpdateService",
		"cache": true
	},
}

var NetworkDatabaseModule = {
	"NetworkServerDatabaseManager": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkServerDatabaseManager",
		"cache": true
	},
	"NetworkMiddlewareManager": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkMiddlewareManager",
		"cache": true
	},
	"NetworkEndpointManager": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkEndpointManager",
		"cache": true
	},
}

var NetworkDatabaseModuleService = {
	"DatabaseServerAuthService": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Service/DatabaseServer/DatabaseServerAuthService",
		"cache": true
	},
	"DatabaseUserLoginService": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Service/DatabaseUser/DatabaseUserLoginService",
		"cache": true
	},
	"DatabaseUserTokenService": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Service/DatabaseUser/DatabaseUserTokenService",
		"cache": true
	},
	"DatabaseCharacterFetchService": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Service/DatabaseCharacter/DatabaseCharacterFetchService",
		"cache": true
	},
	"DatabaseCharacterSelectService": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Service/DatabaseCharacter/DatabaseCharacterSelectService",
		"cache": true
	},
	"DatabaseCharacterUpdateService": {
		"path_tree": "/root/Network/NetworkDatabaseModule/Service/DatabaseCharacter/DatabaseCharacterUpdateService",
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

