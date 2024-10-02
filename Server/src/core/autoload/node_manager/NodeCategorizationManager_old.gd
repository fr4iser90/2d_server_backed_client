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
	#print("runtime_node_map:", runtime_node_map)  # Debugging: output the entire data package

	# Check if the root node exists
	if "root" in runtime_node_map["runtime_node_map"]:
		var root_info = runtime_node_map["runtime_node_map"]["root"]
		#print("Root info found:", root_info)  # Debugging: output the root information

		# Check if children exist in root_info
		if "children" in root_info:
			for module_name in root_info["children"].keys():
				var module_info = root_info["children"][module_name]
				print("Module found:", module_name)  # Debugging: output the found modules

				# Initialize module map
				categorized_runtime_node_map[module_name] = {}

				if "children" in module_info:
					# Iterate through managers
					for manager_name in module_info["children"].keys():
						var manager_info = module_info["children"][manager_name]
						print("Manager found:", manager_name)  # Debugging: output the found managers

						# Ensure manager_info is a dictionary before accessing path_tree
						if typeof(manager_info) == TYPE_DICTIONARY:
							# Save path_tree for the manager
							categorized_runtime_node_map[module_name][manager_name] = {
								"path_tree": manager_info.get("path_tree", ""),
								"children": {}  # Initialize an empty children map
							}

							# Check if the manager has children
							if "children" in manager_info:
								for child_name in manager_info["children"].keys():
									var child_info = manager_info["children"][child_name]
									print("Child found:", child_name)  # Debugging: output the found child

									# Check if child_info is a dictionary
									if typeof(child_info) == TYPE_DICTIONARY:
										categorized_runtime_node_map[module_name][manager_name]["children"][child_name] = {
											"path_tree": child_info.get("path_tree", ""),
											"children": {}  # Initialize for any further children
										}

										# Check if this child has its own children (grandchildren)
										if "children" in child_info:
											for grandchild_name in child_info["children"].keys():
												var grandchild_info = child_info["children"][grandchild_name]
												print("Grandchild found:", grandchild_name)  # Debugging: output the found grandchild

												if typeof(grandchild_info) == TYPE_DICTIONARY:
													categorized_runtime_node_map[module_name][manager_name]["children"][child_name]["children"][grandchild_name] = {
														"path_tree": grandchild_info.get("path_tree", ""),
														"children": {}  # Initialize for grand-grandchildren
													}

													# Check if the grandchild has its own children (grand-grandchildren)
													if "children" in grandchild_info:
														for grandgrandchild_name in grandchild_info["children"].keys():
															var grandgrandchild_info = grandchild_info["children"][grandgrandchild_name]
															print("Grand-Grandchild found:", grandgrandchild_name)  # Debugging: output the found grand-grandchild

															if typeof(grandgrandchild_info) == TYPE_DICTIONARY:
																categorized_runtime_node_map[module_name][manager_name]["children"][child_name]["children"][grandchild_name]["children"][grandgrandchild_name] = {
																	"path_tree": grandgrandchild_info.get("path_tree", "")
																}
									else:
										print("Child info is not a dictionary for:", child_name)
						else:
							print("Manager info is not a dictionary for:", manager_name)

				else:
					print("No children found in module_info.")  # No managers found
		else:
			print("No children found in root_info.")  # No modules found
	else:
		print("No 'root' found in runtime_node_map.")  # Structure not as expected

	save_categorized_node_map()  # Save the map
	
# Function to save the categorized node map
func save_categorized_node_map():
	var file = FileAccess.open(output_file_categorized_runtime_node_map, FileAccess.WRITE)
	if file:
		# Save each module as a separate variable
		for module_name in categorized_runtime_node_map.keys():
			file.store_line("var " + module_name + " = {")
			var manager_map = categorized_runtime_node_map[module_name]
			for manager_name in manager_map.keys():
				file.store_line('    "' + manager_name + '": {')
				file.store_line('        "path_tree": "' + manager_map[manager_name]["path_tree"] + '",')  # Save path_tree

				# Iterate through children (handlers, Config, Map, etc.)
				for child_name in manager_map[manager_name]["children"].keys():
					file.store_line('        "' + child_name + '": {')
					file.store_line('            "path_tree": "' + manager_map[manager_name]["children"][child_name]["path_tree"] + '",')  # Save child path_tree

					# Check for grandchildren
					for grandchild_name in manager_map[manager_name]["children"][child_name]["children"].keys():
						file.store_line('            "' + grandchild_name + '": {')
						file.store_line('                "path_tree": "' + manager_map[manager_name]["children"][child_name]["children"][grandchild_name]["path_tree"] + '",')  # Save grandchild path_tree

						# Check for grand-grandchildren
						for grandgrandchild_name in manager_map[manager_name]["children"][child_name]["children"][grandchild_name]["children"].keys():
							file.store_line('                "' + grandgrandchild_name + '": {')
							file.store_line('                    "path_tree": "' + manager_map[manager_name]["children"][child_name]["children"][grandchild_name]["children"][grandgrandchild_name]["path_tree"] + '",')  # Save grand-grandchild path_tree
							file.store_line('                },')
						file.store_line('            },')
					file.store_line('        },')
				file.store_line('    },')
			file.store_line("}")
			file.store_line("")  # Separate each module with an empty line for readability
		file.close()
		print("Categorized node data saved to file:", output_file_categorized_runtime_node_map)
	else:
		print("Error opening file for writing:", output_file_categorized_runtime_node_map)
