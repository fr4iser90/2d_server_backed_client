extends Node

# Add NPC to an instance
func add_npc_to_instance(instance_key: String, npc_data: Dictionary):
	var instance = GlobalManager.InstanceManager.get_instance_data(instance_key)
	instance["npcs"].append(npc_data)
