# res://src/core/autoloads/node_manager/NodeRetrievalManager.gd
extends Node


var node_cache_manager = preload("res://autoload/node_manager/NodeCacheManager.gd").new()

func _ready():
	if not node_cache_manager:
		print("preloading node cache manager")
		node_cache_manager = preload("res://autoload/node_manager/NodeCacheManager.gd").new()

func get_node_from_config(node_category: String, node_name: String, auto_initialize := true) -> Node:
	if auto_initialize:
		print("called auto initialize")
		return node_cache_manager.init_and_cache_node(node_category, node_name)
	else:
		print("called just get cached node")
		return node_cache_manager.get_cached_node(node_category, node_name)
