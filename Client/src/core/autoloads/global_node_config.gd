extends Node

# Dictionary mit Pfaden zu häufig verwendeten Nodes
var manager = {
	"game_connection_manager": {"path": "/root/NetworkManager/GameConnectionManager", "cache": true},
	"player_movement_manager": {"path": "/root/NetworkManager/PlayerMovementManager", "cache": true},
}

var network_meta_manager = {
	"client_main": {"path": "/root/ClientMain", "cache": true},
	"network_manager": {"path": "/root/NetworkManager", "cache": true},
	"enet_client_manager": {"path": "/root/NetworkManager/MetaManager/ENetClientManager", "cache": true},
	"packet_manager": {"path": "/root/NetworkManager/MetaManager/PacketManager", "cache": true},
	"channel_manager": {"path": "/root/NetworkManager/MetaManager/ChannelManager", "cache": true},
	"global_channel_map": {"path": "/root/NetworkManager/MetaManager/ChannelManager/MetaChannelMap", "cache": true},
}

var world_manager = {
	# Placeholder for future entries
}

var gameplay_manager = {
	# Placeholder for future entries
}

var player_manager = {
	"spawn_manager": {"path": "/root/NetworkManager/GameManager/PlayerManager/SpawnManager", "cache": true},
	"user_manager": {"path": "/root/NetworkManager/GameManager/PlayerManager/UserManager", "cache": true},
	"character_manager": {"path": "/root/NetworkManager/GameManager/PlayerManager/CharacterManager", "cache": true},
	"character_information_manager": {"path": "/root/NetworkManager/GameManager/PlayerManager/CharacterManager/CharacterInformationManager", "cache": true},		
	"movement_manager": {"path": "/root/NetworkManager/GameManager/PlayerManager/MovementManager", "cache": true},
}

var backend_manager = {
	# Placeholder for future entries
}

var basic_handler = {
	"heartbeat_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/HeartbeatHandler", "cache": true},
	"connection_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/ConnectionHandler", "cache": true},
	"disconnection_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/DisconnectionHandler", "cache": true},
	"data_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/DataHandler", "cache": true},
	"chat_messages_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/ChatMessageHandler", "cache": true},
	"player_status_update_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/PlayerStatusUpdateHandler", "cache": true},
	"event_triggered_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/EventTriggeredHandler", "cache": true},
	"special_action_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/SpecialActionHandler", "cache": true},
	"player_movement_handler": {"path": "/root/NetworkManager/MetaHandler/ClientServerHandler/PlayerMovementHandler", "cache": true},
	
}

var backend_handler = {
	"backend_login_handler": {"path": "/root/NetworkManager/MetaHandler/BackendHandler/BackendLoginHandler", "cache": true},
	"backend_character_handler": {"path": "/root/NetworkManager/MetaHandler/BackendHandler/BackendCharactersHandler", "cache": true},
	"backend_character_select_handler": {"path": "/root/NetworkManager/MetaHandler/BackendHandler/BackendCharactersSelectHandler", "cache": true}
}

var ui_handler = {
	# Placeholder for future entries
}

var combat_handler = {
	# Placeholder for future entries
}

var quest_handler = {
	# Placeholder for future entries
}

var misc_handler = {
	# Placeholder for future entries
}

func get_node_info(node_type: String, node_name: String) -> Dictionary:
	var node_dict = null
	match node_type:
		"network_meta_manager":
			node_dict = network_meta_manager
		"player_manager":
			node_dict = player_manager
		"world_manager":
			node_dict = world_manager
		"gameplay_manager":
			node_dict = gameplay_manager
		"backend_manager":
			node_dict = backend_manager
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
		_:
			#print("Error: Invalid node type:", node_type)
			return {}

	if node_dict and node_dict.has(node_name):
		return node_dict[node_name]
	else:
		print("Error: Node name not found in config:", node_name)
		return {}
