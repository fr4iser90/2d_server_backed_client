extends Node



var network_handler = {
	"core_heartbeat_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreHeartBeatHandler", "cache": true},
	"core_connection_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreConnectionHandler", "cache": true},
	"core_disconnection_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreDisconnectionHandler", "cache": true},
	"core_ping_handler": {"path_tree": "/root/Core/Network/Handler/Core/CorePingHandler", "cache": true},
	"core_server_status_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreServerStatusHandler", "cache": true},
	"core_error_handler": {"path_tree": "/root/Core/Network/Handler/Core/CoreErrorHandler", "cache": true},
	"movement_player_handler": {"path_tree": "/root/Core/Network/Handler/Movement/MovementPlayerHandler", "cache": true},
	"movement_player_snc_handler": {"path_tree": "/root/Core/Network/Handler/Movement/MovementPlayerSyncHandler", "cache": true},
	# Backend Handler
	"auth_login_handler": {"path_tree": "/root/Core/Network/Handler/Auth/AuthLoginHandler", "cache": true},
	"char_fetch_handler": {"path_tree": "/root/Core/Network/Handler/Char/CharFetchHandler", "cache": true},
	"char_select_handler": {"path_tree": "/root/Core/Network/Handler/Char/CharSelectHandler", "cache": true}
}

