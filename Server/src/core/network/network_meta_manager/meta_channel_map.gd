extends Node

var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	
# Globale Channel Map für alle Netzwerke
const GLOBAL_CHANNEL_MAP = {
	# Core Network Channels
	0: "heartbeat_handler",         # For keeping the connection alive and tracking client-server health
	1: "connection_handler",        # For managing connection events such as client joining the server
	2: "disconnection_handler",     # For managing disconnection events when a client leaves the server
	
	# Scene and Spawn Data
	10: "scene_data_handler",       # For scene loading, instance creation, and spawn points
	11: "position_data_handler",    # For position sync between client and server
	12: "spawn_data_handler",       # For handling player spawn at specific points (or last known positions)
	
	# Movement and Player Control
	20: "player_movement_handler",    # For player movement updates (e.g., walking, running)
	21: "player_movement_sync_in_instance_handler",  # Spielerbewegungen innerhalb der Instanz synchronisieren
	
	# Combat and Abilities
	30: "combat_handler",           # For combat-related actions and updates (e.g., attack damage)
	31: "special_ability_handler",  # For combat-related abilities used by players (e.g., spells, skills)
	
	# Chat and Communication
	40: "chat_messages_handler",    # For chat or other communication messages between players
	41: "guild_chat_handler",       # For guild-specific communication
	42: "party_chat_handler",       # For party-specific communication
	
	# Item and Inventory Management
	50: "inventory_update_handler", # For inventory updates (e.g., item picked up, item used)
	51: "stash_update_handler",     # For stash updates (e.g., items moved into or out of the stash)
	52: "equipment_change_handler", # For when a player equips or unequips items (e.g., weapons, armor)
	
	# Quest and Objectives
	60: "quest_data_handler",       # For quest updates (e.g., progress, completion, new quest assigned)
	61: "quest_status_handler",     # For reporting quest status changes (e.g., completed objectives)
	
	# Status and Buffs/Debuffs
	70: "status_update_handler",    # For status updates like health, mana, stamina, and experience
	71: "buff_debuff_handler",      # For applying buffs and debuffs (e.g., status effects, power-ups)
	
	# Party and Guild Management
	80: "party_update_handler",     # For party-related updates (e.g., party invites, member status)
	81: "guild_update_handler",     # For guild-related updates (e.g., guild invites, member status)

	# World Events and Interactions
	90: "event_triggered_handler",  # For world events or player-triggered events (e.g., opening a chest)
	91: "npc_interaction_handler",  # For interactions with NPCs (e.g., buying, selling, talking)

	# Trade and Economy
	100: "trade_request_handler",   # For trade requests between players
	101: "trade_update_handler",    # For updating trade status or confirming a trade
	102: "market_update_handler",   # For marketplace interactions (e.g., listing items for sale)

	# Miscellaneous or Special Actions
	110: "special_action_handler",  # For any special actions not covered by other channels
	111: "teleport_handler",        # For teleporting players to different locations (e.g., fast travel)
	112: "resource_sync_handler",   # For syncing world resources like ores, herbs, etc.
	
	# Authentication and User Management
	9000: "backend_login_handler",               # For login authentication (user credentials, tokens)
	9001: "backend_logout_handler",              # For logging users out
	9002: "backend_register_handler",            # For registering new users
	
	# Character Management
	9010: "backend_character_handler",           # For fetching character lists
	9011: "backend_character_create_handler",    # For creating new characters
	9012: "backend_character_delete_handler",    # For deleting characters
	9013: "backend_character_update_handler",    # For updating character information (e.g., stats, inventory)
	9014: "backend_character_select_handler",    # For selecting and loading characters

	# Inventory and Stash Management
	9020: "backend_inventory_fetch_handler",     # For fetching inventory data from the backend
	9021: "backend_inventory_update_handler",    # For updating inventory (e.g., item added, removed, used)
	9022: "backend_stash_fetch_handler",         # For fetching stash data (global or per-character)
	9023: "backend_stash_update_handler",        # For updating stash contents
	
	# Quest and Progression Management
	9030: "backend_quest_fetch_handler",         # For fetching active quests from the backend
	9031: "backend_quest_update_handler",        # For updating quest progress or completion status
	9032: "backend_quest_accept_handler",        # For accepting a new quest
	9033: "backend_quest_decline_handler",       # For declining or abandoning a quest
	
	# Trade and Economy
	9040: "backend_market_fetch_handler",        # For fetching items listed in a marketplace
	9041: "backend_market_update_handler",       # For updating marketplace listings (e.g., posting, buying, selling)
	9042: "backend_trade_request_handler",       # For handling trade requests between players
	9043: "backend_trade_update_handler",        # For updating trade status or confirming trades
	
	# Guild and Party Management
	9050: "backend_guild_fetch_handler",         # For fetching guild-related data (guild roster, info)
	9051: "backend_guild_update_handler",        # For updating guild-related information (e.g., member roles)
	9052: "backend_party_fetch_handler",         # For fetching active party members
	9053: "backend_party_update_handler",        # For updating party info (e.g., member status, disbanding)
	
	# Admin and Server Management
	9060: "backend_server_status_handler",       # For fetching server status (e.g., uptime, resource usage)
	9061: "backend_admin_action_handler",        # For admin-specific actions (e.g., banning players, granting permissions)
	
	# Player Data Sync and Updates
	9070: "backend_data_sync_handler",           # For syncing player data across servers
	9071: "backend_stats_update_handler",        # For updating player stats (e.g., health, mana, experience)
	9072: "backend_skill_update_handler",        # For updating skills and abilities (e.g., new skills learned, skill points)
	
	# Combat, PvP, and PvE Events
	9080: "backend_combat_log_handler",          # For handling backend combat logging (PvP, PvE)
	9081: "backend_arena_info_handler",          # For managing backend arena or competitive events
	
	# Chat and Communication
	9090: "backend_chat_moderation_handler",     # For moderating chat messages (e.g., muting, banning from chat)
	9091: "backend_broadcast_message_handler",   # For sending broadcast messages to all players
	
	# Miscellaneous
	9100: "backend_special_action_handler",      # For handling any special backend actions or commands
	9101: "backend_logging_handler",             # For backend logging actions (player actions, errors)
}

func get_channel_handler(channel: int) -> String:
	return GLOBAL_CHANNEL_MAP.get(channel, "unknown_channel")

