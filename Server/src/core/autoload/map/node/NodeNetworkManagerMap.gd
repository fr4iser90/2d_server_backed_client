# res://src/core/autoload/map/node/NodeNetworkManagerMap.gd
extends Node


var network_meta_manager = {
	"network_manager": {"path_tree": "/root/Core/Network", "cache": true},
	"network_server_client_manager": {"path_tree": "/root/Core/Network/NetworkServerClientManager", "cache": true},
	"network_server_backend_manager": {"path_tree": "/root/Core/Network/NetworkServerBackendManager", "cache": true},
	"enet_server_manager": {"path_tree": "/root/Core/Network/Manager/ENetServerManager", "cache": true},
	"packet_manager": {"path_tree": "/root/Core/Network/Manager/PacketManager", "cache": true},
	"channel_manager": {"path_tree": "/root/Core/Network/Manager/ChannelManager", "cache": true},
	"channel_map": {"path_tree": "/root/Core/Network/Manager/ChannelManager/ChannelMap", "cache": true, "initialize": true},
	"user_session_manager": {"path_tree": "/root/User/Manager/UserSessionManager", "cache": true},
}

