# res://src/core/autoload/map/node/NodeSceneManagerMap.gd
extends Node


var scene_manager = {
	"scene_cache_manager": {"name": "SceneCacheManager", "path_file": "res://src/core/autoload/scene_manager/SceneCacheManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneCacheManager", "cache": true},
	"scene_loading_manager": {"name": "SceneLoadingManager", "path_file": "res://src/core/autoload/scene_manager/SceneLoadingManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneLoadingManager", "cache": true},
	"scene_config_manager": {"name": "SceneConfig", "path_file": "res://src/core/autoload/scene_manager/SceneConfigManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneConfigManager", "cache": true},
	"scene_overlay_manager": {"name": "SceneOverlayManager", "path_file": "res://src/core/autoload/scene_manager/SceneOverlayManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneOverlayManager", "cache": true},
	#"scene_audio_manager": {"name": "SceneAudioManager", "path_file": "res://src/core/autoload/scene_manager/SceneAudioManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneAudioManager", "cache": true},
	#"scene_event_manager": {"name": "SceneEventManager", "path_file": "res://src/core/autoload/scene_manager/SceneEventManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneEventManger", "cache": true},
	#"scene_physics_manager": {"name": "ScenePhysicsManager", "path_file": "res://src/core/autoload/scene_manager/ScenePhysicsManager.gd", "path_tree": "/root/GlobalManager/SceneManager/ScenePhysicsManager", "cache": true},
	#"scene_lighting_manager": {"name": "SceneLightingManager", "path_file": "res://src/core/autoload/scene_manager/SceneLightingManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneLightningManager", "cache": true},
	"scene_transition_manager": {"name": "SceneTransitionManager", "path_file": "res://src/core/autoload/scene_manager/SceneTransitionManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneTransitionManager", "cache": true},
	"scene_state_manager": {"name": "SceneStateManager", "path_file": "res://src/core/autoload/scene_manager/SceneStateManager.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneStateManager", "cache": true},
	"scene_scanner": {"name": "SceneScanner", "path_file": "res://src/core/autoload/scene_manager/SceneScanner.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneScanner", "cache": true},
}
