extends Node


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
	# Einfach auf den SceneManager zugreifen, da er nun global über Autoload verfügbar ist
	GlobalManager.SceneManager.switch_scene("main_menu")
