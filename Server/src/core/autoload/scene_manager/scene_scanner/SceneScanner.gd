# SceneScanner
extends Node

# Path to the start directory to be scanned
var start_directory = "res://src"

# Path to the shared directory for assets and scenes
var shared_directory = "res://shared"

# Output file for the scenes
var output_file = "res://src/core/autoload/map/GlobalSceneMap.gd"

# Flag to indicate if the scan has been completed
var scanner_done = false

signal scan_complete

func start_scan():
	print("SceneScanner started, consider deactivating after developing.")
	# Check if the scanner has already been executed
	if scanner_done:
		print("Scanner has already been executed, skipping.")
	else:
		# Scan both the project and shared directories
		var scenes = scan_and_merge_scenes(start_directory, shared_directory)
		
		if scenes_changed(scenes, output_file):
			save_scene_paths(scenes, output_file)
		else:
			print("No changes detected, file will not be overwritten.")
		scanner_done = true
		emit_signal("scan_complete")

func scan_and_merge_scenes(project_dir: String, shared_dir: String) -> Dictionary:
	var project_scenes = get_scene_paths(project_dir)
	var shared_scenes = get_scene_paths(shared_dir)
	
	# Combine both scene dictionaries
	var all_scenes = project_scenes.duplicate()
	for key in shared_scenes.keys():
		all_scenes[key] = shared_scenes[key]  # Manually add shared scenes to the project scenes
	
	return all_scenes
	
func _ready():
	start_scan()
	pass

# Recursive function to traverse the directory and capture scene paths
func get_scene_paths(directory: String, base_category: String = "") -> Dictionary:
	var dir = DirAccess.open(directory)
	var scenes = {}

	if dir != null:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				var category = base_category
				
				# Main category checks
				if directory.find("core") != -1:
					category = "scene_cores"
				elif directory.find("menus") != -1:
					category = "scene_menus"
				elif directory.find("players") != -1:
					category = "scene_players"
				elif directory.find("worlds") != -1:
					category = "scene_worlds"
				elif directory.find("towns") != -1:
					category = "scene_towns"
				elif directory.find("encampments") != -1:
					category = "scene_encampments"
				elif directory.find("levels") != -1:
					category = "scene_levels"
				elif directory.find("dungeons") != -1:
					category = "scene_dungeons"
				elif directory.find("enemies") != -1:
					# Enemy rarity checks
					if directory.find("common") != -1:
						category = "scene_enemies_common"
					elif directory.find("uncommon") != -1:
						category = "scene_enemies_uncommon"
					elif directory.find("rare") != -1:
						category = "scene_enemies_rare"
					else:
						category = "scene_enemies"
				elif directory.find("bosses") != -1:
					category = "scene_bosses"
				elif directory.find("items") != -1:
					if directory.find("consumables") != -1:
						category = "scene_items_consumables"
					elif directory.find("equipment") != -1:
						category = "scene_items_equipment"
					elif directory.find("quest") != -1:
						category = "scene_items_quest"
					else:
						category = "scene_items"
				elif directory.find("effects") != -1:
					category = "scene_effects"
				elif directory.find("sound") != -1:
					category = "scene_sounds"
				elif directory.find("npcs") != -1:
					category = "scene_npcs"
				elif directory.find("abilities") != -1:
					category = "scene_abilities"
				elif directory.find("quests") != -1:
					category = "scene_quests"
				elif directory.find("dialogue") != -1:
					category = "scene_dialogue"
				elif directory.find("interfaces") != -1:
					# UI-related elements such as stash, inventory, and others
					category = "scene_interfaces"
				else:
					category = base_category if base_category != "" else "misc_scenes"

				var sub_scenes = get_scene_paths(directory + "/" + file_name, category)
				
				# Add the found scenes to `scenes`
				for key in sub_scenes.keys():
					scenes[key] = sub_scenes[key]
				
			elif file_name.ends_with(".tscn"):
				var scene_name = file_name.replace(".tscn", "")
				var category_name = base_category if base_category != "" else "misc_scenes"
				scenes[category_name + "/" + scene_name] = directory + "/" + file_name
			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Error opening directory:", directory)

	return scenes

# Checks if the scene paths have changed
func scenes_changed(new_scenes: Dictionary, output_file: String) -> bool:
	# Load the contents of the existing file
	var existing_content = ""
	var file = FileAccess.open(output_file, FileAccess.READ)
	if file != null:
		existing_content = file.get_as_text().strip_edges()  # Read the entire content of the file
		file.close()
	else:
		print("No existing file found. Changes detected.")
		return true  # If the file doesn't exist, it's considered changed

	# Generate the new scene string
	var new_content = generate_scene_config_string(new_scenes).strip_edges()

	# Remove whitespace (spaces, tabs, newlines) before comparison
	existing_content = existing_content.replace("\n", "").replace("\t", "").replace(" ", "")
	new_content = new_content.replace("\n", "").replace("\t", "").replace(" ", "")

	# Calculate the hashes for comparison
	var existing_hash = hash_string(existing_content)
	var new_hash = hash_string(new_content)

	# Compare the hashes
	return existing_hash != new_hash

# Function to generate the content of the scene config file as a string
func generate_scene_config_string(scenes: Dictionary) -> String:
	var content = "extends Node\n\n"
	var categories = {}

	# Szenen nach Kategorie organisieren
	for scene_name in scenes.keys():
		var category = scene_name.split("/")[0]
		if not categories.has(category):
			categories[category] = {}
		categories[category][scene_name.replace(category + "/", "")] = scenes[scene_name]

	# Für jede Kategorie die Szenen hinzufügen
	for category in categories.keys():
		content += "var %s = {\n" % category
		for scene_name in categories[category].keys():
			content += '    "%s": "%s",\n' % [scene_name, categories[category][scene_name]]
		content += "}\n\n"

	# Dynamische Funktion zum Abrufen des Szenenpfads basierend auf der Kategorie
	content += "func get_scene_path(scene_name: String) -> String:\n"
	content += "    scene_name = scene_name\n"
	for category in categories.keys():
		content += "    if %s.has(scene_name):\n" % category
		content += "        return %s[scene_name]\n" % category
	content += '    else:\n'
	content += '        print("Error: Scene name not found in config:", scene_name)\n'
	content += '        return ""\n'

	return content

# Function to hash a string (simple method to ensure string comparison)
func hash_string(data: String) -> int:
	var hash = 0
	var prime = 31  # Use a prime number for hashing
	var byte_array = data.to_utf8_buffer()  # Convert the string to an array of bytes (UTF-8)
	for i in range(byte_array.size()):
		hash = (hash * prime + byte_array[i]) % 2147483647  # Access the byte representation
	return hash

# Saves the collected scene paths to the configuration file
func save_scene_paths(scenes: Dictionary, output_file: String):
	var file = FileAccess.open(output_file, FileAccess.WRITE)
	if file != null:
		var content = generate_scene_config_string(scenes)
		file.store_string(content)
		file.close()
		print("Scene paths saved to file:", output_file)
	else:
		print("Error opening file:", output_file)
