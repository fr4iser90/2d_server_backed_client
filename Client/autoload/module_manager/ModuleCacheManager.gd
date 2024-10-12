# res://src/core/autoloads/module_manager/ModuleCacheManager.gd
extends Node


func cache_module(module_name: String):
	var module_info = node_config.get_module_info(module_name)
	if not module_info:
		print("Error: Invalid module name", module_name)
		return

	if not node_cache.has(module_name) and module_info["cache"]:
		var module_path = module_info["path"]
		var module = preload(module_path).new()
		node_cache[module_name] = module
		node_flags[module_name] = {"is_initialized": false, "is_ready": false}
		print("Module cached:", module_name)
