# NPCStateHandler.gd
extends Node

var instance_manager


@onready var npc_spawning_handler = $"../NPCSpawningHandler"

func initialize():
	instance_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "instance_manager")
	print("NPCStateManager initialized.")

# Update NPC states based on their current state and AI logic
func _process(delta: float):
	_update_npc_states(delta)

func _update_npc_states(delta: float):
	for instance_key in npc_spawning_handler.spawned_npcs.keys():
		var npcs_in_instance = npc_spawning_handler.spawned_npcs[instance_key]
		for npc in npcs_in_instance:
			if npc.is_inside_tree():
				npc.update_npc_state(delta)
