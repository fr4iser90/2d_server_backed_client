# res://src/core/autoload/map/node/NodeBackendManagerMap.gd
extends Node


var backend_manager = {
	"backend_middleware_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/BackendMiddlewareManager", "cache": true},
	"backend_routes_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/BackendRoutesManager", "cache": true},
	"network_server_backend_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager", "cache": true},
	"auth_server_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/AuthServerManager", "cache": true},
	"auth_token_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/AuthTokenManager", "cache": true},
}

var auth_manager = {
	"auth_server_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/AuthServerManager", "cache": true},
	"auth_token_manager": {"path_tree": "/root/Core/NetworkManager/NetworkServerBackendManager/Manager/AuthTokenManager", "cache": true},
}
