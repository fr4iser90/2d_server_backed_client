# res://src/core/autoloads/module_manager/ModuelBackendMapManager.gd
extends Node

var module_backend_map = {
	"RestAPI": { 
		"dependencies": [], 
		"version": "1.0", 
		"description": "Handles communication with RESTful APIs",
		"protocols": ["HTTP"],
		"backend_required": true,
		"path": "res://modules/backend/rest_api.gd",
		"additional_data": {} 
	},
	"WebSocketBackend": { 
		"dependencies": [], 
		"version": "2.0", 
		"description": "Handles backend WebSocket communication",
		"protocols": ["WebSocket"],
		"backend_required": true,
		"path": "res://modules/backend/websocket_backend.gd",
		"additional_data": {} 
	},
	"AuthServerManager": { 
		"dependencies": ["RestAPI"], 
		"version": "1.0", 
		"description": "Manages authentication with the backend server",
		"backend_required": true,
		"path": "res://modules/backend/auth_server_manager.gd",
		"additional_data": {} 
	},
	"AuthTokenManager": { 
		"dependencies": ["AuthServerManager"], 
		"version": "1.0", 
		"description": "Handles authentication tokens for user validation",
		"backend_required": true,
		"path": "res://modules/backend/auth_token_manager.gd",
		"additional_data": {} 
	},
	"BackendMiddlewareManager": { 
		"dependencies": [], 
		"version": "1.0", 
		"description": "Handles middleware components in the backend",
		"backend_required": true,
		"path": "res://modules/backend/backend_middleware_manager.gd",
		"additional_data": {} 
	},
	"BackendRoutesManager": { 
		"dependencies": ["BackendMiddlewareManager"], 
		"version": "1.0", 
		"description": "Manages the routing of backend API requests",
		"backend_required": true,
		"path": "res://modules/backend/backend_routes_manager.gd",
		"additional_data": {} 
	}
}
