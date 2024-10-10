# NPCMovementManager.gd
extends Node

var navigation_mesh_manager

func initialize():
	navigation_mesh_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "navigation_mesh_manager")
	print("NPCMovementManager initialized.")

# Move NPC towards a target position
func move_npc(npc_instance: Node, target_position: Vector2, delta: float):
	var path = navigation_mesh_manager.calculate_path(npc_instance.position, target_position)
	npc_instance.move_along_path(path, delta)
