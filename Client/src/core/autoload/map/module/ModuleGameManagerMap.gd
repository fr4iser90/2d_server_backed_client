extends Node


var module_game_manager_map = {
	"PlayerManager": { 
		"dependencies": [], 
		"version": "1.0", 
		"description": "Manages player-related functions, including spawning and controlling players",
		"path": "res://modules/game/player_manager.gd",
		"additional_data": {}
	},
	"CharacterManager": { 
		"dependencies": ["PlayerManager"], 
		"version": "1.0", 
		"description": "Manages character data and attributes for players",
		"path": "res://modules/game/character_manager.gd",
		"additional_data": {}
	},
	"PlayerMovementManager": { 
		"dependencies": ["PlayerManager"], 
		"version": "1.0", 
		"description": "Handles player movement, including input and physics",
		"path": "res://modules/game/player_movement_manager.gd",
		"additional_data": {}
	},
	"InstanceManager": { 
		"dependencies": [], 
		"version": "1.0", 
		"description": "Manages instances for multiplayer, including player instance creation and synchronization",
		"path": "res://modules/game/instance_manager.gd",
		"additional_data": {}
	},
	"SpawnManager": { 
		"dependencies": ["InstanceManager"], 
		"version": "1.0", 
		"description": "Handles the spawning of players and entities in the game world",
		"path": "res://modules/game/spawn_manager.gd",
		"additional_data": {}
	},
	"MapGeneratorManager": { 
		"dependencies": [], 
		"version": "1.0", 
		"description": "Generates maps or levels procedurally",
		"path": "res://modules/game/map_generator_manager.gd",
		"additional_data": {}
	},
	"PlayerVisualMonitorManager": { 
		"dependencies": ["PlayerManager"], 
		"version": "1.0", 
		"description": "Monitors player visual data and updates the game world accordingly",
		"path": "res://modules/game/player_visual_monitor_manager.gd",
		"additional_data": {}
	},
	"PlayerMonitorManager": { 
		"dependencies": ["PlayerManager"], 
		"version": "1.0", 
		"description": "Monitors player-related data such as health, status, and position",
		"path": "res://modules/game/player_monitor_manager.gd",
		"additional_data": {}
	}
}
