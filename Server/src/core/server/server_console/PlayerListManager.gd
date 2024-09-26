# res://src/core/server/server_console/PlayerListManager.gd (Server)
extends ItemList



var player_visual_monitor
var selected_player_index = -1
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	player_visual_monitor  = GlobalManager.NodeManager.get_cached_node("server_manager", "player_visual_monitor")
	# Connect to the user_data_changed signal from UserSessionManager
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	if user_session_manager:
		user_session_manager.connect("user_data_changed", self, "update_player_list")
	connect("item_activated", Callable(self, "_on_item_activated"))

func update_player_list(changed_peer_id: int, user_data: Dictionary):
	clear()  # Clear existing items
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	for id in user_session_manager.users_data.keys():
		var user = user_session_manager.users_data[id]
		var username = user.get("username", "Unknown")
		var current_instance = user.get("current_instance", "No Instance")
		
		# Retrieve nested character data
		var character_data = user.get("character", {})

		var character_name = character_data.get("name", "No Character")
		var current_scene = character_data.get("scene_name", "No Scene")
		
		# Build the main list item text
		var item_text = "Username: %s, Character: %s, Scene: %s" % [username, character_name, current_scene]
		add_item(item_text)
		
		# Construct the tooltip
		var tooltip_text = construct_tooltip_text(user, id)
		set_item_tooltip(get_item_count() - 1, tooltip_text)

func construct_tooltip_text(user: Dictionary, id: int) -> String:
	return "Username: %s\nPeerID: %s\nUserID: %s\nToken: %s\nOnline: %s" % [
		user.get("username", "Unknown"),
		str(id),
		user.get("user_id", "No ID"),
		user.get("token", "No Token"),
		str(user.get("is_online", false))
	]

# Handle double-click event
func _on_item_activated(index):
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	if user_session_manager:
		var user = user_session_manager.users_data.values()[index]  # Retrieve the user data based on selected index
		var instance_key = user.get("current_instance", "")
		
		if instance_key != "" and player_visual_monitor:
			player_visual_monitor.show_scene_instnace_window(instance_key)

# Optional: Adjust the tooltip size to fit within the viewport
func adjust_tooltip_position(tooltip: String, mouse_position: Vector2):
	var screen_size = get_viewport().get_visible_rect().size
	var tooltip_size = get_theme_default_font().get_string_size(tooltip)

	# Adjust tooltip position if it's going off-screen
	if mouse_position.x + tooltip_size.x > screen_size.x:
		mouse_position.x = screen_size.x - tooltip_size.x
	if mouse_position.y + tooltip_size.y > screen_size.y:
		mouse_position.y = screen_size.y - tooltip_size.y

	return mouse_position

# Handle single-click to store the selected player index
func _on_item_selected(index):
	selected_player_index = index  # Store the selected index

# Handle button press for watching the selected player
func _on_watch_pressed():
	if selected_player_index >= 0:
		_watch_selected_player(selected_player_index)
	else:
		print("No player selected.")


# Watch the selected player
func _watch_selected_player(index):
	var player_visual_monitor = GlobalManager.NodeManager.get_cached_node("server_manager", "player_visual_monitor")
	var user_session_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "user_session_manager")
	if user_session_manager:
		var user = user_session_manager.users_data.values()[index]  # Retrieve the user data based on selected index
		var instance_key = user.get("current_instance", "")
		var peer_id = user.get("peer_id", -1)  # Get the peer_id of the selected player
		if instance_key != "" and player_visual_monitor:
			player_visual_monitor.show_scene_instance_window(instance_key, peer_id)  # Pass instance_key and peer_id
		else:
			print("Instance key not found or player_visual_monitor not available")


