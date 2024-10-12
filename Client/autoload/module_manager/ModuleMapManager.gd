extends Node

extends Node

var module_network_manager_map = {

}

var module_backend_manager_map = {
res://src/core/autoloads/module_manager/ModuleBackendMapManager.gd
}

var module_UserSessionModule_map = {


}

var module_game_manager_map = {

	}
}

func check_compatibility(module_name: String) -> bool:
	var module = module_network_map.get(module_name)
	if module == null:
		print("Error: Module " + module_name + " not found!")
		return false
	
	for dependency in module["dependencies"]:
		if not module_network_map.has(dependency):
			print("Error: Dependency " + dependency + " for " + module_name + " is missing!")
			return false
	
	print("All dependencies for " + module_name + " are satisfied.")
	return true
