# res://src/core/network/manager/server_client_enet_packet_peer/manager/channel_map.gd (Server)
extends Node

var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	
# Global Channel Map with Logical Groupings and Prefixes for Consistency
const CHANNEL_MAP = {
	# --- 0-999: Core Network Management ---
	0: "CoreHeartbeatService",
	1: "CoreConnectionService",
	2: "CoreDisconnectionService",
	3: "CorePingService",
	4: "CoreServerStatusService",
	5: "CoreErrorService",
	6: "CoreServerRestartService",
	7: "CoreServerShutdownService",
	8: "CoreVersionCheckService",
	9: "CoreConfigSyncService",
	10: "CoreMaintenanceModeService",
	11: "CoreNetworkDiagnosticsService",
	12: "CoreBandwidthUsageService",
	13: "CoreSyncTimeService",

	# --- 1000-1999: Authentication and User Management ---
	1000: "UserLoginService",
	1001: "UserLogoutService",
	1002: "UserRegisterService",
	1003: "UserPasswordResetService",
	1004: "UserTokenRefreshService",
	1005: "UserAccountVerificationService",
	1006: "UserSessionTimeoutService",
	1007: "UserMultifactorAuthService",
	1008: "UserRevokeTokenService",
	1009: "UserLoginAttemptService",
	1010: "UserPrivacySettingsService",
	1011: "UserBanAccountService",
	1012: "UserProfileFetchService",
	1013: "UserProfileUpdateService",
	1014: "UserAccountRecoveryService",
	1015: "UserDeviceManagementService",

	# --- 2000-2999: Character Management ---
	2000: "CharacterFetchService",
	2001: "CharacterCreateService",
	2002: "CharacterDeleteService",
	2003: "CharacterUpdateService",
	2004: "CharacterSelectService",
	2005: "CharacterCustomizationService",
	2006: "CharacterAttributeUpdateService",
	2007: "CharacterClassChangeService",

	# --- 3000-3999: Scene and Interaction Data Management ---
	3000: "SceneInstanceDataService",
	3002: "SceneSpawnService",
	3003: "SceneInstanceTransitionService",
	3004: "SceneObjectInteractionService",
	3005: "SceneDoorService",
	3006: "SceneTrapDoorService",
	3007: "SceneSpecialDoorService",
	3008: "SceneLeverService",
	3009: "SceneButtonService",
	
	# --- 4000-4999: Player and NPC Movement ---
	4000: "MovementPlayerService",
	4001: "MovementPlayerSyncService",
	4002: "MovementNpcService",
	4003: "MovementEnemyService",
	4004: "MovementFlyingService",
	4005: "MovementTeleportService",

	# --- 5000-5999: Combat and Abilities ---
	5000: "CombatActionService",
	5001: "CombatSpecialAbilityService",
	5002: "CombatRangedAttackService",
	5003: "CombatMeleeAttackService",
	5004: "CombatDamageService",
	5005: "CombatHealingService",
	5006: "CombatStatusEffectService",

	# --- 6000-6999: Chat and Communication ---
	6000: "ChatMessageService",
	6001: "ChatGuildService",
	6002: "ChatPartyService",
	6003: "ChatWhisperService",
	6004: "ChatGlobalService",
	6005: "ChatSystemService",

	# --- 7000-7999: Item and Inventory Management ---
	7000: "InventoryUpdateService",
	7001: "InventoryDropService",
	7002: "InventoryEquipService",
	7003: "InventoryStackService",
	7004: "InventorySplitService",
	7005: "StashUpdateService",
	7006: "EquipmentChangeService",

	# --- 8000-8999: Quest and Objectives ---
	8000: "QuestDataService",
	8001: "QuestStatusService",
	8002: "QuestAcceptService",
	8003: "QuestDeclineService",
	8004: "QuestRewardService",
	8005: "QuestObjectiveUpdateService",

	# --- 9000-9999: Status and Buffs/Debuffs ---
	9000: "StatusUpdateService",
	9001: "StatusEffectService",
	9002: "BuffApplyService",
	9003: "DebuffApplyService",
	9004: "BuffRemoveService",
	9005: "DebuffRemoveService",

	# --- 10000-10999: Party and Guild Management ---
	10000: "PartyCreateService",
	10001: "PartyInviteService",
	10002: "PartyUpdateService",
	10003: "PartyDisbandService",
	10004: "GuildCreateService",
	10005: "GuildInviteService",
	10006: "GuildUpdateService",
	10007: "GuildDisbandService",

	# --- 11000-11999: World Events and Interactions ---
	11000: "EventTriggerService",
	11001: "NpcInteractionService",
	11002: "WorldEventService",
	11003: "EnvironmentInteractionService",

	# --- 12000-12999: Trade and Economy ---
	12000: "TradeRequestService",
	12001: "TradeUpdateService",
	12002: "MarketUpdateService",
	12003: "MarketPurchaseService",
	12004: "AuctionPlaceBidService",
	12005: "AuctionWinService",

	# --- 13000-13999: Miscellaneous or Special Actions ---
	13000: "MiscSpecialActionService",
	13001: "MiscTeleportService",
	13002: "MiscResourceSyncService",
	13003: "MiscEmoteService",

	# --- 14000-14999: Trigger Management ---
	14000: "TriggerEntryService",
	14001: "TriggerExitService",
	14002: "TriggerInstanceChangeService",
	14003: "TriggerRoomChangeService",
	14004: "TriggerEventService",
	14005: "TriggerTrapService",
	14006: "TriggerObjectiveService",

	# --- 90000-99999: Admin and Backend ---
	90000: "AdminLoginService",
	90001: "AdminLogoutService",
	90002: "AdminRegisterService",
	90010: "AdminServerStatusService",
	90011: "AdminActionService",
	90012: "AdminBroadcastMessageService",
	90013: "AdminLogFetchService",
}

# Function to get handler name from a channel
func get_channel_handler(channel: int) -> String:
	return CHANNEL_MAP.get(channel, "unknown_channel")
