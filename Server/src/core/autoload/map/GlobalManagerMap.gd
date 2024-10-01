# res://src/core/autoload/map/GlobalManagerMap.gd
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
	"scene_spawn_point_scanner": {"name": "SceneSpawnPointScanner", "path_file": "res://src/core/autoload/scene_manager/SceneSpawnPointScanner.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneSpawnPointScanner", "cache": true},
	"scene_trigger_scanner": {"name": "SceneTriggerScanner", "path_file": "res://src/core/autoload/scene_manager/SceneTriggerScanner.gd", "path_tree": "/root/GlobalManager/SceneManager/SceneTriggerScanner", "cache": true},
}

var node_manager = {
	"node_map_manager": {"name": "NodeMapManager", "path_file": "res://src/core/autoload/node_manager/NodeMapManager.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeMapManager", "cache": true},
	"node_cache_manager": {"name": "NodeCacheManager", "path_file": "res://src/core/autoload/node_manager/NodeCacheManager.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeCacheManager", "cache": true},
	"node_state_manager": {"name": "NodeStateManager", "path_file": "res://src/core/autoload/node_manager/NodeStateManager.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeStateManager", "cache": true},
	"node_life_cycle_manager": {"name": "NodeLifecycleManager", "path_file": "res://src/core/autoload/node_manager/NodeLifecycleManager.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeLifecycleManager", "cache": true},
	"node_retrieval_manager": {"name": "NodeRetrievalManager", "path_file": "res://src/core/autoload/node_manager/NodeRetrievalManager.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeRetrievalManager", "cache": true},
	"node_temporary_manager": {"name": "NodeTemporaryManager", "path_file": "res://src/core/autoload/node_manager/TemporaryNodeManager.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeTemporaryManager", "cache": true},
	"node_scanner": {"name": "NodeScanner", "path_file": "res://src/core/autoload/node_manager/NodeScanner.gd", "path_tree": "/root/GlobalManager/NodeManager/NodeScanner", "cache": true},
}

func get_data() -> Dictionary:
	var all_data = {}

	# Get the list of properties (variables) in the current script
	var properties = get_property_list()

	# Iterate through the properties and add any Dictionary-type variables to all_data
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)

		# Ensure that only Dictionary-type variables are added
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = property_value

	return all_data


