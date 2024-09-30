# res://src/core/server/preset/database_godot/server_init_manager.gd
extends Node

var core_tree
var	network_tree
var	user_tree
var	game_tree
var server_initialized = false

signal all_managers_initialized

func _ready():
	core_tree = GlobalManager.SceneManager.load_scene("CoreTree")
	user_tree = GlobalManager.SceneManager.load_scene("UserTree")
	game_tree = GlobalManager.SceneManager.load_scene("GameTree")
	
	emit_signal("all_managers_initialized")



