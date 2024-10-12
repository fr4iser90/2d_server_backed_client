# NPCSpawningHandler.gd
extends Node

# Reference to the NPCManager
var npc_manager

# Global Managers
var instance_manager

func initialize(manager: Node):
	npc_manager = manager  # Store the reference to the NPCManager
	instance_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceManager")
	
	print("NPCSpawningHandler initialized.")

# Spawn an NPC in a specific instance
func spawn_npc(npc_type: String, instance_key: String, spawn_position: Vector2):
	if not instance_manager.has_instance(instance_key):
		print("Instance not found:", instance_key)
		return

	# Load the NPC scene and instantiate the NPC
	var npc_scene = load("res://scenes/npcs/" + npc_type + ".tscn")
	if npc_scene:
		var npc_instance = npc_scene.instantiate()
		npc_instance.position = spawn_position

		# Add the NPC to the instance node in the scene tree
		var instance_node = instance_manager.get_instance_node(instance_key)
		if instance_node:
			instance_node.add_child(npc_instance)
			_register_npc(instance_key, npc_instance)
			print("NPC spawned at position:", spawn_position, "in instance:", instance_key)
		else:
			print("Failed to add NPC to instance. Node not found for instance_key:", instance_key)

# Register the NPC in the NPCManager's dictionary
func _register_npc(instance_key: String, npc_instance: Node):
	if not npc_manager.spawned_npcs.has(instance_key):
		npc_manager.spawned_npcs[instance_key] = []
	npc_manager.spawned_npcs[instance_key].append(npc_instance)
