# res://src/core/autoload/map/GameMap.gd
extends Node

var game_player_module = {
	"player_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager", "cache": true},
	"character_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager", "cache": true},
	"player_movement_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager", "cache": true},
	"player_state_manager": {"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerStateManager", "cache": true},
}

var game_world_module = {
	"instance_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager", "cache": true},
	"trigger_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager", "cache": true},
	"chunk_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager", "cache": true},
	"spawn_point_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/SpawnPointManager", "cache": true},
	"world_loader": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager", "cache": true},
	"entity_node_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/EntityNodeManager", "cache": true},
	"navigation_mesh_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/NavigationMeshManager", "cache": true},
}

var game_entity_module  = {
	"npc_manager": {"path_tree": "/root/Game/GameEntityModule/Manager/NPCManager", "cache": true},
	"mod_manager": {"path_tree": "/root/Game/GameEntityModule/Manager/MobManager", "cache": true},
}

var instance_manager_handler = {
	"instance_lifecycle_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceLifecycleHandler", "cache": true},
	"instance_cache_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceCacheHandler", "cache": true},
	"instance_assignment_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceAssignmentHandler", "cache": true},
	"instance_entity_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceEntityManager", "cache": true},
	"instance_scene_manager": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceSceneManager", "cache": true},
	"instance_player_character_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstancePlayerCharacterHandler", "cache": true},
	"instance_npc_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceNPCHandler", "cache": true},
	"instance_mob_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceMobHandler", "cache": true},
	"instance_state_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceStateHandler", "cache": true},
	"instance_event_handler": {"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceEventHandler", "cache": true},
}

func get_data() -> Dictionary:
	var all_data = {}

	# Get the list of properties (variablenochmlqas) in the current script
	var properties = get_property_list()

	# Iterate through the properties and add any Dictionary-type variables to all_data
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)

		# Ensure that only Dictionary-type variables are added
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = property_value

	return all_data


