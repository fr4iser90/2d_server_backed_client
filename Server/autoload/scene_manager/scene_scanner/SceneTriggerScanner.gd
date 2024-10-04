extends Node

# Dictionary to store paths and trigger collision data of triggers
var trigger_data = {}

# Directory to scan scenes
var start_directory = "res://shared/data/levels"

# Scan scenes for specific triggers (RoomChange, ZoneChange, etc.)
func scan_scenes_for_triggers():
	var scenes = get_scene_paths(start_directory)
	for scene_name in scenes.keys():
		var scene_path = scenes[scene_name]
		_find_triggers_in_scene(scene_name, scene_path)

# Retrieve all scene paths from the directory
func get_scene_paths(directory: String) -> Dictionary:
	var dir = DirAccess.open(directory)
	var scenes = {}

	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				var sub_scenes = get_scene_paths(directory + "/" + file_name)
				for key in sub_scenes.keys():
					scenes[key] = sub_scenes[key]
			elif file_name.ends_with(".tscn"):
				var scene_name = file_name.replace(".tscn", "")
				scenes[scene_name] = directory + "/" + file_name
			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Error opening directory:", directory)

	return scenes

# Scan specific scene and collect all relevant triggers
func _find_triggers_in_scene(scene_name: String, scene_path: String):
	var packed_scene = load(scene_path)
	if packed_scene is PackedScene:
		var scene_instance = packed_scene.instantiate()

		# Initialize categorized triggers
		var categorized_triggers = {
			"room_change_trigger": {},
			"zone_change_trigger": {},
			"instance_change_trigger": {},
			"event_trigger": {},
			"trap_trigger": {},
			"objective_trigger": {}
		}

		# Search for the main node: Trigger
		var trigger_node = scene_instance.get_node_or_null("Trigger")
		if trigger_node:
			_find_trigger_points_recursive(trigger_node, categorized_triggers)

		# Save only if valid triggers were found
		var has_valid_triggers = false
		for key in categorized_triggers.keys():
			if categorized_triggers[key].size() > 0:
				has_valid_triggers = true
				break
		
		if has_valid_triggers:
			trigger_data[scene_name] = categorized_triggers
			print("Found categorized triggers: ", _format_trigger_data(trigger_data))
		else:
			print("No triggers found in scene:", scene_name)

# Recursive search for TriggerCollisionShapes and building the simplified path
func _find_trigger_points_recursive(node: Node, categorized_triggers: Dictionary, path_prefix: String = ""):
	var current_path = path_prefix + "/" + node.name if path_prefix != "" else node.name

	for child in node.get_children():
		if child is Node2D or child is CollisionObject2D:
			# Scan for TriggerCollisionShape2D in all relevant triggers
			if child.name.find("TriggerCollisionShape2D") != -1:
				# Simplify path by removing Trigger group prefix and store it
				var simplified_path = _simplify_path(current_path)

				# Precalculate the rectangular bounds of the trigger area
				var min_position = child.global_position - child.shape.extents
				var max_position = child.global_position + child.shape.extents
				var trigger_bounds = Rect2(min_position, max_position - min_position)  # Storing as a Rect2

				# Categorize based on trigger type
				if current_path.find("RoomChangeTrigger") != -1:
					categorized_triggers["room_change_trigger"][simplified_path] = {
						"global_position": child.global_position,
						"area_size": child.shape.extents,
						"trigger_bounds": trigger_bounds  # Precomputed bounds
					}
				elif current_path.find("ZoneChangeTrigger") != -1:
					categorized_triggers["zone_change_trigger"][simplified_path] = {
						"global_position": child.global_position,
						"area_size": child.shape.extents,
						"trigger_bounds": trigger_bounds
					}
				elif current_path.find("InstanceChangeTrigger") != -1:
					categorized_triggers["instance_change_trigger"][simplified_path] = {
						"global_position": child.global_position,
						"area_size": child.shape.extents,
						"trigger_bounds": trigger_bounds
					}
				# Repeat for other trigger types...

			# Continue recursion even if the node was found
			_find_trigger_points_recursive(child, categorized_triggers, current_path)

# Utility function to simplify the node path, removing the Trigger prefixes
func _simplify_path(full_path: String) -> String:
	# Simplify the path by removing Trigger group prefixes
	var prefix_list = ["RoomChangeTrigger", "ZoneChangeTrigger", "InstanceChangeTrigger", "EventTrigger", "TrapTrigger", "ObjectiveTrigger"]
	for prefix in prefix_list:
		if full_path.find(prefix) != -1:
			return full_path.replace("Trigger/" + prefix + "/", "")
	return full_path

# Format and print the trigger data in a sorted, clean way
func _format_trigger_data(trigger_data: Dictionary) -> String:
	var formatted_output = ""
	for scene_name in trigger_data.keys():
		formatted_output += "\nScene: " + scene_name + "\n"
		var scene_data = trigger_data[scene_name]

		for category in scene_data.keys():
			if scene_data[category].size() > 0:
				formatted_output += "  " + category.capitalize() + ":\n"
				for trigger_name in scene_data[category].keys():
					var info = scene_data[category][trigger_name]
					formatted_output += "    - " + trigger_name + ": global_position = " + str(info["global_position"]) + ", area_size = " + str(info["area_size"]) + "\n"
	return formatted_output

# Function to get pre-scanned trigger data
func get_trigger_data() -> Dictionary:
	return trigger_data
	
# Utility to retrieve triggers for a specific scene
func get_triggers_for_scene(scene_name: String) -> Dictionary:
	return trigger_data.get(scene_name, {})

# Save the collected triggers to a file (optional)
func save_triggers_to_file(output_file: String):
	var file = FileAccess.open(output_file, FileAccess.WRITE)
	if file != null:
		var content = JSON.stringify(trigger_data)
		file.store_string(content)
		file.close()
		print("Triggers saved to file:", output_file)
	else:
		print("Error opening file:", output_file)
