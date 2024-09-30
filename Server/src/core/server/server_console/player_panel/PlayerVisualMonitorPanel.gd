# res://src/core/server/scene/PlayerVisualMonitorPanel.gd (Server)
extends Panel  # This stays a Panel node

var player_visual_monitor  # Reference to the PlayerVisualMonitor node

var is_initialized = false

# Initialize the PlayerVisualMonitor
func initialize():
	if is_initialized:
		return
	is_initialized = true
	player_visual_monitor = GlobalManager.NodeManager.get_cached_node("server_manager", "player_visual_monitor")

# Function to trigger scene monitoring for a specific instance_key
func monitor_instance(instance_key: String):
	if player_visual_monitor:
		player_visual_monitor.show_scene_instance_window(instance_key, self)  # Pass the current panel (self) as the container
	else:
		print("Error: PlayerVisualMonitor is not initialized.")
