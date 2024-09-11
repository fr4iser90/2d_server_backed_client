extends Node

func _ready():
	if GlobalManager:
		GlobalManager.connect("global_manager_ready", Callable(self, "_on_global_manager_ready"))
		GlobalManager.check_all_managers_ready()
	else:
		var timer = Timer.new()
		timer.set_wait_time(1.0)
		timer.set_one_shot(true)
		add_child(timer)
		timer.connect("timeout", Callable(self, "_ready"))
		get_node("retry_timer").start()
		
func _on_global_manager_ready():
	# Einfach auf den SceneManager zugreifen, da er nun global über Autoload verfügbar ist
	GlobalManager.GlobalSceneManager.switch_scene("main_menu")
