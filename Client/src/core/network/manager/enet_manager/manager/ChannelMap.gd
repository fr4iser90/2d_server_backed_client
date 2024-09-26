extends Node

# Globale Channel Map für alle Netzwerke
const CHANNEL_MAP = {
	# --- 0-999: Core Network Management ---
	0: "core_heartbeat_handler",          # Keep the connection alive and track client-server health
	1: "core_connection_handler",         # Handle when a client joins the server
	2: "core_disconnection_handler",      # Handle when a client leaves the server
	3: "core_ping_handler",               # Handle ping/pong messages to check latency
	4: "core_server_status_handler",      # Handle requests for the server's current status
	5: "core_error_handler",              # Handle general network errors
	6: "core_server_restart_handler",     # Handle server restart requests or notices
	7: "core_server_shutdown_handler",    # Handle server shutdown requests or notices
	8: "core_version_check_handler",      # Handle version checks between client and server
	9: "core_config_sync_handler",        # Handle synchronization of server configurations to clients
	10: "core_maintenance_mode_handler",  # Handle notices or events during server maintenance mode
	11: "core_network_diagnostics_handler", # Handle network diagnostics and troubleshooting
	12: "core_bandwidth_usage_handler",   # Track and report bandwidth usage per client or server-wide
	13: "core_sync_time_handler",         # Handle synchronization of time between clients and server

	# --- 1000-1999: Authentication and User Management ---
	1000: "auth_login_handler",           # Handle login requests (credentials, tokens)
	1001: "auth_logout_handler",          # Handle logout requests
	1002: "auth_register_handler",        # Handle user registration
	1003: "auth_password_reset_handler",  # Handle password reset requests
	1004: "auth_token_refresh_handler",   # Handle refresh of authentication tokens
	1005: "auth_account_verification_handler", # Handle account verification (e.g., email or phone)
	1006: "auth_session_timeout_handler", # Handle session timeout notifications
	1007: "auth_multifactor_auth_handler",# Handle multi-factor authentication (e.g., OTP, app-based)
	1008: "auth_revoke_token_handler",    # Handle revocation of authentication tokens
	1009: "auth_login_attempt_handler",   # Track login attempts and lockout on multiple failures
	1010: "auth_privacy_settings_handler",# Handle updates to user privacy settings
	1011: "auth_ban_account_handler",     # Handle account bans and user restrictions
	1012: "auth_user_profile_fetch_handler", # Fetch basic user profile data
	1013: "auth_user_profile_update_handler", # Handle updates to user profile (e.g., avatar, bio)
	1014: "auth_account_recovery_handler",# Handle account recovery process (e.g., security questions)
	1015: "auth_device_management_handler",# Handle device management for user sessions (e.g., logout from specific devices)

	# --- 2000-2999: Character Management ---
	2000: "char_fetch_handler",         # Fetch the list of characters
	2001: "char_create_handler",        # Handle character creation
	2002: "char_delete_handler",        # Handle character deletion
	2003: "char_update_handler",        # Update character information (stats, inventory, etc.)
	2004: "char_select_handler",        # Handle character selection and loading
	2005: "char_customization_handler", # Handle character customization (appearance changes)
	2006: "char_attribute_update_handler", # Update character attributes (strength, agility, etc.)
	2007: "char_class_change_handler",  # Handle character class change requests

	# --- 3000-3999: Scene and Spawn Data Management ---
	3000: "scene_instance_data_handler",         # Handle scene loading, instance creation, and spawn points
	3001: "scene_position_sync_handler",# Synchronize player positions between client and server
	3002: "scene_spawn_handler",        # Handle player spawns at specific points or last known positions
	3003: "scene_instance_transition_handler", # Handle transitions between instances
	3004: "scene_object_interaction_handler",  # Handle interaction with objects in the scene (doors, chests, etc.)

	# --- 4000-4999: Player and NPC Movement ---
	4000: "movement_player_handler",    # Handle player movement updates (e.g., walking, running)
	4001: "movement_player_sync_handler", # Synchronize player movement within an instance
	4002: "movement_npc_handler",       # Handle NPC movement updates (e.g., patrols, following)
	4003: "movement_enemy_handler",     # Handle enemy movement and pathfinding (e.g., chasing players)
	4004: "movement_flying_handler",    # Handle flying entities or flight abilities
	4005: "movement_teleport_handler",  # Handle teleportation of players/NPCs to different locations

	# --- 5000-5999: Combat and Abilities ---
	5000: "combat_action_handler",      # Handle combat actions (e.g., dealing damage)
	5001: "combat_special_ability_handler", # Handle special abilities (e.g., spells, skills)
	5002: "combat_ranged_attack_handler",# Handle ranged attacks (e.g., arrows, spells)
	5003: "combat_melee_attack_handler", # Handle melee combat actions (e.g., sword strikes)
	5004: "combat_damage_handler",       # Handle damage taken and applied to entities
	5005: "combat_healing_handler",      # Handle healing abilities
	5006: "combat_status_effect_handler",# Handle status effects applied in combat (e.g., stuns, poisons)

	# --- 6000-6999: Chat and Communication ---
	6000: "chat_message_handler",       # Handle general chat messages between players
	6001: "chat_guild_handler",         # Handle guild-specific communication
	6002: "chat_party_handler",         # Handle party-specific communication
	6003: "chat_whisper_handler",       # Handle direct messages between players (whispers)
	6004: "chat_global_handler",        # Handle global chat messages (available to all players)
	6005: "chat_system_handler",        # Handle system announcements or warnings

	# --- 7000-7999: Item and Inventory Management ---
	7000: "inventory_update_handler",   # Handle inventory updates (e.g., items picked up, used)
	7001: "inventory_drop_handler",     # Handle when items are dropped from inventory
	7002: "inventory_equip_handler",    # Handle equipping and unequipping items
	7003: "inventory_stack_handler",    # Handle stacking items in the inventory
	7004: "inventory_split_handler",    # Handle splitting item stacks
	7005: "stash_update_handler",       # Handle stash updates (e.g., items moved into or out of stash)
	7006: "equipment_change_handler",   # Handle when a player equips or unequips items

	# --- 8000-8999: Quest and Objectives ---
	8000: "quest_data_handler",         # Handle quest updates (e.g., progress, completion)
	8001: "quest_status_handler",       # Report quest status changes (e.g., completed objectives)
	8002: "quest_accept_handler",       # Handle accepting new quests
	8003: "quest_decline_handler",      # Handle declining or abandoning quests
	8004: "quest_reward_handler",       # Handle giving rewards to players for quest completion
	8005: "quest_objective_update_handler", # Handle updates to quest objectives (e.g., kill X enemies)

	# --- 9000-9999: Status and Buffs/Debuffs ---
	9000: "status_update_handler",      # Handle status updates (e.g., health, mana, experience)
	9001: "status_effect_handler",      # Apply status effects (e.g., poisoned, stunned)
	9002: "buff_apply_handler",         # Handle applying buffs to players/NPCs
	9003: "debuff_apply_handler",       # Handle applying debuffs to players/NPCs
	9004: "buff_remove_handler",        # Handle removal of buffs
	9005: "debuff_remove_handler",      # Handle removal of debuffs

	# --- 10000-10999: Party and Guild Management ---
	10000: "party_create_handler",      # Handle creating a party
	10001: "party_invite_handler",      # Handle party invites
	10002: "party_update_handler",      # Handle party updates (e.g., invites, member status)
	10003: "party_disband_handler",     # Handle disbanding a party
	10004: "guild_create_handler",      # Handle creating a guild
	10005: "guild_invite_handler",      # Handle guild invites
	10006: "guild_update_handler",      # Handle guild updates (e.g., invites, member status)
	10007: "guild_disband_handler",     # Handle disbanding a guild

	# --- 11000-11999: World Events and Interactions ---
	11000: "event_trigger_handler",     # Handle world or player-triggered events (e.g., opening a chest)
	11001: "npc_interaction_handler",   # Handle interactions with NPCs (e.g., buying, selling, talking)
	11002: "world_event_handler",       # Handle world events (e.g., server-wide events, invasions)
	11003: "environment_interaction_handler", # Handle interactions with the environment (e.g., mining, chopping trees)

	# --- 12000-12999: Trade and Economy ---
	12000: "trade_request_handler",     # Handle trade requests between players
	12001: "trade_update_handler",      # Update trade status or confirm a trade
	12002: "market_update_handler",     # Handle marketplace interactions (e.g., posting items for sale)
	12003: "market_purchase_handler",   # Handle purchases from the marketplace
	12004: "auction_place_bid_handler", # Handle placing bids in auctions
	12005: "auction_win_handler",       # Handle auction win notifications

	# --- 13000-13999: Miscellaneous or Special Actions ---
	13000: "misc_special_action_handler", # Handle special actions not covered by other channels
	13001: "misc_teleport_handler",     # Handle player teleportation (e.g., fast travel)
	13002: "misc_resource_sync_handler",# Sync world resources like ores, herbs, etc.
	13003: "misc_emote_handler",        # Handle player emotes (e.g., waving, dancing)

	# --- 90000-99999: Admin and Backend ---
	90000: "admin_login_handler",       # Handle backend login (user authentication)
	90001: "admin_logout_handler",      # Handle backend logout
	90002: "admin_register_handler",    # Handle backend user registration
	90010: "admin_server_status_handler", # Fetch backend server status (e.g., uptime, resource usage)
	90011: "admin_action_handler",      # Handle admin-specific actions (e.g., banning players)
	90012: "admin_broadcast_message_handler", # Broadcast messages to all players
	90013: "admin_log_fetch_handler",   # Fetch logs from the server
}

func get_channel_handler(channel: int) -> String:
	return CHANNEL_MAP.get(channel, "unknown_channel")
