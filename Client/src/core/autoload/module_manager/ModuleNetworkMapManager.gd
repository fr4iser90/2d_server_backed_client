# res://src/core/autoloads/module_manager/ModuleNetworkMapManager.gd
extends Node

var module_network_map = {
	"connection": {
		"ENetPacketPeer": { 
			"dependencies": [], 
			"version": "1.0", 
			"description": "Handles ENet-based networking",
			"protocols": ["UDP"],
			"backend_required": false,
			"path": "res://modules/network/enet_packet_peer.gd",
			"additional_data": {} 
		},
		"MultiplayerAPI": { 
			"dependencies": ["ENetPacketPeer"], 
			"version": "1.0", 
			"description": "High-level multiplayer API for synchronizing players across the network",
			"protocols": ["UDP", "TCP"],
			"backend_required": false,
			"path": "res://modules/network/multiplayer_api.gd",
			"additional_data": {} 
		},
		"WebSocket": { 
			"dependencies": [], 
			"version": "2.0", 
			"description": "Handles WebSocket-based networking",
			"protocols": ["WebSocket"],
			"backend_required": false,
			"path": "res://modules/network/websocket.gd",
			"additional_data": {} 
		},
		"NetworkMonitor": { 
			"dependencies": ["MultiplayerAPI"], 
			"version": "1.0", 
			"description": "Monitors network status, ping, and performance",
			"protocols": ["UDP", "TCP", "WebSocket"],
			"backend_required": false,
			"path": "res://modules/network/network_monitor.gd",
			"additional_data": {} 
		},
		"NetworkRetryManager": { 
			"dependencies": ["MultiplayerAPI"], 
			"version": "1.0", 
			"description": "Manages reconnections and retries in case of network failures",
			"protocols": ["UDP", "TCP"],
			"backend_required": false,
			"path": "res://modules/network/network_retry_manager.gd",
			"additional_data": {} 
		}
	},
	"data_handling": {
		"ChannelManager": { 
			"dependencies": ["ENetPacketPeer"], 
			"version": "1.0", 
			"description": "Handles network channels, manages routing between channels",
			"path": "res://modules/network/channel_manager.gd",
			"backend_required": false,
			"additional_data": {}
		},
		"PacketManager": { 
			"dependencies": ["ENetPacketPeer"], 
			"version": "1.0", 
			"description": "Manages network packets, handling serialization and deserialization",
			"path": "res://modules/network/packet_manager.gd",
			"backend_required": false,
			"additional_data": {}
		},
		"SerializationManager": { 
			"dependencies": [], 
			"version": "1.0", 
			"description": "Handles serialization and deserialization of data for network transmission",
			"path": "res://modules/data_handling/serialization_manager.gd",
			"backend_required": false,
			"additional_data": {}
		},
		"EncryptionManager": { 
			"dependencies": [], 
			"version": "1.0", 
			"description": "Encrypts and decrypts network packets for secure communication",
			"path": "res://modules/data_handling/encryption_manager.gd",
			"backend_required": false,
			"additional_data": {}
		},
		"CompressionManager": { 
			"dependencies": [], 
			"version": "1.0", 
			"description": "Compresses and decompresses data for efficient network transmission",
			"path": "res://modules/data_handling/compression_manager.gd",
			"backend_required": false,
			"additional_data": {}
		},
		"DataValidationManager": { 
			"dependencies": [], 
			"version": "1.0", 
			"description": "Validates incoming and outgoing data packets to ensure data integrity",
			"path": "res://modules/data_handling/data_validation_manager.gd",
			"backend_required": false,
			"additional_data": {}
		}
	}
}
