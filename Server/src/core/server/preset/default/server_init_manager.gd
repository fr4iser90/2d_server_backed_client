# res://src/core/server/preset/default/server_init_manager.gd
extends Node

var core_tree
var	network_tree
var	user_tree
var	game_tree
var server_initialized = false

signal all_managers_initialized

func _ready():
	if GlobalManager:
		print("GlobalManager available, waiting for signal")
		GlobalManager.connect("global_manager_ready", Callable(self, "_on_global_manager_ready"))
		_check_global_manager_status()
	else:
		_retry_check_global_manager()

func _retry_check_global_manager():
	var timer = Timer.new()
	timer.set_wait_time(1.0)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", Callable(self, "_ready"))
	timer.start()

func _check_global_manager_status():
	GlobalManager._check_node_manager_readiness()

func _on_global_manager_ready():
	print("GlobalManager is ready, initializing ServerInit managers...")
	server_initialized = true
	# Lade den core_tree
	core_tree = GlobalManager.SceneManager.load_scene("CoreTree")
	user_tree = GlobalManager.SceneManager.load_scene("UserTree")
	game_tree = GlobalManager.SceneManager.load_scene("GameTree")
	
	emit_signal("all_managers_initialized")
