# res://src/core/autoloads/module_manager/ModuleLifecycleManager.gd
extends Node


func initialize_module(module_name: String):
	if not node_state_manager.check_node_ready(module_name):
		var module = node_cache_manager.get
