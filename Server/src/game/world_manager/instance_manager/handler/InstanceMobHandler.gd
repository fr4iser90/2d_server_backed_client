extends Node

# Add mobs to an instance
func add_mob_to_instance(instance_key: String, mob_data: Dictionary):
	var instance = GlobalManager.InstanceManager.get_instance_data(instance_key)
	instance["mobs"].append(mob_data)
