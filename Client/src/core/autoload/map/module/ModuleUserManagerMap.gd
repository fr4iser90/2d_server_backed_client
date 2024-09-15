extends Node


var module_user_manager_map = {
	"UserSessionManager": { 
		"dependencies": ["AuthServerManager"], 
		"version": "1.0", 
		"description": "Manages user sessions with the backend",
		"backend_required": true,
		"path": "res://modules/user_data/user_session_manager.gd",
		"additional_data": {} 
	},
	"UserSessionManagerNoBackend": { 
		"dependencies": [], 
		"version": "1.0", 
		"description": "Manages user sessions locally without backend support",
		"backend_required": false,
		"path": "res://modules/user_data/user_session_manager_no_backend.gd",
		"additional_data": {} 
	},
	"UserDataPersistence": { 
		"dependencies": ["UserSessionManager"], 
		"version": "1.0", 
		"description": "Handles data persistence for user data (e.g., saving game progress)",
		"backend_required": true,
		"path": "res://modules/user_data/user_data_persistence.gd",
		"additional_data": {} 
	}
}
