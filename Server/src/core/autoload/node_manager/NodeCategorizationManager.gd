extends Node

# Preload the runtime node map script
var runtime_node_map_script = preload("res://src/core/autoload/map/RuntimeNodeMap.gd")
var output_file_categorized_runtime_node_map = "res://src/core/autoload/map/CategorizedRuntimeNodeMap.gd"

# Initialize the categorized map
var categorized_runtime_node_map = {}

# Collects all manager maps and saves them
func process_and_save_categorized_node_data():
	var instance = runtime_node_map_script.new()  # Create an instance
	var runtime_node_map = instance.get_data()  # Get data from the instance

	# Process the root node
	if "root" in runtime_node_map["runtime_node_map"]:
		var root_info = runtime_node_map["runtime_node_map"]["root"]
		if "children" in root_info:
			for module_name in root_info["children"].keys():
				var module_info = root_info["children"][module_name]
				print("Module found:", module_name)
				
				# Initialize module map
				categorized_runtime_node_map[module_name] = {}
				
				# Process the module's children recursively
				process_node_hierarchy(module_info, categorized_runtime_node_map[module_name])

	save_categorized_node_map()  # Save the map

# Recursive function to process node hierarchy (managers, children, grandchildren, etc.)
func process_node_hierarchy(node_info: Dictionary, result_map: Dictionary):
	if "children" in node_info:
		for child_name in node_info["children"].keys():
			var child_info = node_info["children"][child_name]
			print("Node found:", child_name)

			# Ensure the child is a dictionary and add its path_tree
			if typeof(child_info) == TYPE_DICTIONARY:
				result_map[child_name] = {
					"path_tree": child_info.get("path_tree", ""),
					"children": {}  # Prepare for further nesting
				}

				# Recursively process the node's children (grandchildren, etc.)
				process_node_hierarchy(child_info, result_map[child_name]["children"])

# Function to save the categorized node map
func save_categorized_node_map():
	var file = FileAccess.open(output_file_categorized_runtime_node_map, FileAccess.WRITE)
	if file:
		# Save each module as a separate variable
		for module_name in categorized_runtime_node_map.keys():
			file.store_line("var " + module_name + " = {")
			var manager_map = categorized_runtime_node_map[module_name]
			save_node_hierarchy(manager_map, file, "    ")
			file.store_line("}")
			file.store_line("")  # Separate each module with an empty line for readability
		append_get_data_function(file)
		file.close()
		print("Categorized node data saved to file:", output_file_categorized_runtime_node_map)
	else:
		print("Error opening file for writing:", output_file_categorized_runtime_node_map)

# Recursive function to save node hierarchy into the file
func save_node_hierarchy(node_map: Dictionary, file: FileAccess, indent: String):
	for node_name in node_map.keys():
		file.store_line(indent + '"' + node_name + '": {')
		file.store_line(indent + '    "path_tree": "' + node_map[node_name]["path_tree"] + '",')

		# Save children recursively if they exist
		if "children" in node_map[node_name] and node_map[node_name]["children"].keys().size() > 0:
			file.store_line(indent + '    "children": {')
			save_node_hierarchy(node_map[node_name]["children"], file, indent + '        ')
			file.store_line(indent + '    }')

		file.store_line(indent + '},')

func append_get_data_function(file: FileAccess):
	# Define the get_data() utility function content
	var function_content = """
func get_data() -> Dictionary:
	var all_data = {}
	var properties = get_property_list()
		
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)
			
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = flatten_nested_map(property_value)
		
	return all_data

func flatten_nested_map(nested_map: Dictionary) -> Dictionary:
	var flat_map = {}
		
	for key in nested_map.keys():
		var value = nested_map[key]
		
		if typeof(value) == TYPE_DICTIONARY and value.has('children'):
			flat_map[key] = value
			flat_map[key]['children'] = flatten_nested_map(value['children'])
		else:
			flat_map[key] = value
	
	return flat_map
"""
	# Append the function content to the file
	file.store_line(function_content)
