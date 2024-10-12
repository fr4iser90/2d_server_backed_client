# SignalManager
extends Node

var manager_status = {
	"node_manager": false,
	"scene_manager": false,
	#"network_manager": false,
	# Add other managers as needed
}

signal all_managers_ready

func _ready():
	# Connect signals from each manager to listen when they are ready
	GlobalManager.NodeManager.connect("node_manager_ready", Callable(self, "_on_node_manager_ready"))
	GlobalManager.SceneManager.connect("scene_manager_ready", Callable(self, "_on_scene_manager_ready"))
	#GlobalManager.NetworkManager.connect("network_manager_ready", Callable(self, "_on_network_manager_ready"))

	# Optionally, setup a periodic check to verify readiness
	var check_timer = Timer.new()
	check_timer.wait_time = 1.0
	check_timer.one_shot = false
	check_timer.connect("timeout", Callable(self, "_check_ready_status"))
	add_child(check_timer)
	check_timer.start()

func _on_node_manager_ready():
	manager_status["node_manager"] = true
	_check_all_managers_ready()

func _on_scene_manager_ready():
	manager_status["scene_manager"] = true
	_check_all_managers_ready()

func _on_network_manager_ready():
	manager_status["network_manager"] = true
	_check_all_managers_ready()

# Check if all managers are ready and emit the signal
func _check_all_managers_ready():
	# Check if all manager statuses are True
	var all_ready = true
	for status in manager_status.values():
		if not status:
			all_ready = false
			break

	if all_ready:
		print("All managers are ready.")
		emit_signal("all_managers_ready")


# Optionally, a timer that periodically checks the status of all managers
func _check_ready_status():
	_check_all_managers_ready()

# Public function to get the current status of a manager
func is_manager_ready(manager_name: String) -> bool:
	return manager_status.get(manager_name, false)
