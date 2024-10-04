# res://src/core/autoloads/module_manager/ModuleCompatibilityManager.gd
extends Node


var compatibility_matrix = {
	"ModuleA": { "compatible_with": ["ModuleB", "ModuleC"], "incompatible_with": ["ModuleD"] },
	"ModuleD": { "compatible_with": ["ModuleE"], "incompatible_with": ["ModuleA", "ModuleB"] }
}

func check_and_convert(module_name: String) -> bool:
	var module = compatibility_matrix.get(module_name)
	if module == null:
		return false

	for incompatible_module in module["incompatible_with"]:
		if active_modules.has(incompatible_module):
			print("Warning: " + module_name + " is incompatible with " + incompatible_module)
			# Führe ggf. eine automatische Konvertierung durch
			return false
	
	print(module_name + " is compatible with the current setup.")
	return true

func check_compatibility(module_name: String) -> bool:
	var module = module_map.get(module_name)
	if module == null:
		return false

	# Überprüfe, ob das Backend erforderlich ist
	if module["backend_required"] != backend_enabled:
		print("Error: Module " + module_name + " requires a different backend mode!")
		return false

	# Überprüfe Abhängigkeiten
	for dependency in module["dependencies"]:
		if not module_map.has(dependency):
			print("Error: Dependency " + dependency + " for " + module_name + " is missing!")
			return false
	
	print("All dependencies for " + module_name + " are satisfied.")
	return true
