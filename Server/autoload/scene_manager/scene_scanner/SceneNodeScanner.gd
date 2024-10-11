extends Node

var runtime_node_map = {}
var output_file_runtime_node_map = "res://autoload/map/RuntimeNodeMap.gd"

# Laufzeit-Node-Map scannen und speichern
func scan_runtime_node_map():
	var root_node = get_tree().root
	if root_node:
		runtime_node_map.clear()
		runtime_node_map["root"] = _build_node_hierarchy(root_node)
		save_runtime_sorted_node_data_to_file(runtime_node_map, output_file_runtime_node_map)
	else:
		print("No root node found.")

# Rekursive Node-Hierarchie aufbauen
func _build_node_hierarchy(node: Node) -> Dictionary:
	var node_map = {}
	node_map["path_tree"] = str(node.get_path())
	node_map["type"] = node.get_class()
	var children = {}
	for child in node.get_children():
		if child is Node:
			children[child.name] = _build_node_hierarchy(child)
	if children.size() > 0:
		node_map["children"] = children
	return node_map

# Speichern der Node-Daten in Datei (nur speichern, wenn sich die Daten geändert haben)
func save_runtime_sorted_node_data_to_file(node_data: Dictionary, file_path: String):
	# Load existing data from the file for comparison
	var existing_data = load_existing_runtime_node_data(file_path)

	# Compare existing data with the new node_data using the deep comparison function
	if existing_data.has("runtime_node_map") and are_dicts_equal(existing_data["runtime_node_map"], node_data):
		print("No changes detected in runtime node map. Skipping save.")
		return
	else:
		print("Changes detected. Saving data.")
		
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file != null:
		var content = "extends Node\n\nvar runtime_node_map = {\n"
		content += _format_node_map(node_data, 1)
		content += "}\n"

		# Hier wird die get_data() Funktion hinzugefügt
		content += "\nfunc get_data() -> Dictionary:\n"
		content += "\tvar all_data = {}\n\n"
		content += "\t# Get the list of properties (variablenochmlqas) in the current script\n"
		content += "\tvar properties = get_property_list()\n\n"
		content += "\t# Iterate through the properties and add any Dictionary-type variables to all_data\n"
		content += "\tfor property in properties:\n"
		content += "\t\tvar property_name = property.name\n"
		content += "\t\tvar property_value = get(property_name)\n\n"
		content += "\t\t# Ensure that only Dictionary-type variables are added\n"
		content += "\t\tif typeof(property_value) == TYPE_DICTIONARY:\n"
		content += "\t\t\tall_data[property_name] = property_value\n\n"
		content += "\treturn all_data\n"
		
		file.store_string(content)
		file.close()
		GlobalManager.NodeManager.categorize_and_save_runtime_node_map()
	else:
		print("Fehler beim Öffnen der Datei:", file_path)

# Formatierung des Node-Baums
func _format_node_map(node_map: Dictionary, indent_level: int) -> String:
	var content = ""
	var indent = "    ".repeat(indent_level)
	for node_name in node_map.keys():
		var node_info = node_map[node_name]
		content += '%s"%s": {\n' % [indent, node_name]
		content += '%s    "path_tree": "%s",\n' % [indent, node_info["path_tree"]]
		if node_info.has("children"):
			content += '%s    "children": {\n' % indent
			content += _format_node_map(node_info["children"], indent_level + 2)
			content += '%s    },\n' % indent
		content += "%s},\n" % indent
	return content
	
# Funktion zum Laden vorhandener Node-Daten
func load_existing_runtime_node_data(file_path: String) -> Dictionary:
	var existing_data = {}
	
	# Check if the file exists
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file != null:
			var content = file.get_as_text()
			file.close()

			# Parse the runtime_node_map from the existing file content
			var existing_script = load(file_path)
			if existing_script != null:
				# Create an instance of the script to call its methods
				var script_instance = existing_script.new()
				if script_instance.has_method("get_data"):
					existing_data = script_instance.get_data()
				else:
					print("Fehler: Konnte get_data() nicht finden oder ausführen.")
			else:
				print("Fehler beim Laden des Skripts:", file_path)
		else:
			print("Fehler beim Öffnen der Datei zum Lesen:", file_path)
	else:
		print("Datei existiert nicht:", file_path)

	# Always return a Dictionary, even if the file doesn't exist or load fails
	return existing_data

# Deep comparison of two dictionaries
func are_dicts_equal(dict1: Dictionary, dict2: Dictionary) -> bool:
	if dict1.size() != dict2.size():
		return false
	
	for key in dict1.keys():
		if not dict2.has(key):
			return false
		var value1 = dict1[key]
		var value2 = dict2[key]
		
		# If the value is a dictionary, compare recursively
		if typeof(value1) == TYPE_DICTIONARY and typeof(value2) == TYPE_DICTIONARY:
			if not are_dicts_equal(value1, value2):
				return false
		elif value1 != value2:
			return false
	
	return true
