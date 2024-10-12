extends Node

# Function to create and show a scene in a popup
func show_scene_popup(scene_instance: Node):
	var popup = Popup.new()
	popup.rect_min_size = Vector2(600, 400)
	popup.add_child(scene_instance)
	popup.popup()
	get_tree().root.add_child(popup)

# Function to show a scene in a window
func show_scene_window(scene_instance: Node):
	var sub_viewport = SubViewport.new()
	sub_viewport.size = Vector2(800, 600)

	var sub_viewport_container = SubViewportContainer.new()
	sub_viewport_container.add_child(sub_viewport)

	var window = Window.new()
	window.set_min_size(Vector2(800, 600))
	window.title = "Instance Viewer"
	window.add_child(sub_viewport_container)

	sub_viewport.add_child(scene_instance)
	window.popup_centered()
	get_tree().root.add_child(window)
