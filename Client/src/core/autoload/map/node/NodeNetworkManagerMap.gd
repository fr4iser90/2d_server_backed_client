# res://src/core/autoload/map/node/NodeNetworkManagerMap.gd
extends Node


var network_meta_manager = {
	"network_manager": {"path_tree": "/root/Core/NetworkManager", "cache": true},
	"enet_client_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/ENetClientManager", "cache": true},
	"packet_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/PacketManager", "cache": true},
	"channel_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/ChannelManager", "cache": true},
	"channel_map": {"path_tree": "/root/Core/NetworkManager/MetaManager/ChannelManager/ChannelMap", "cache": true, "initialize": true},
	"user_session_manager": {"path_tree": "/root/Core/NetworkManager/MetaManager/UserSessionManager", "cache": true},
}

