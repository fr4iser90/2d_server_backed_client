extends Node

var categorized_map = {}
var output_file_runtime_node_map = "res://autoload/map/FlattenedRuntimeNodeMap.gd"

# Scans the runtime node tree and creates a structured list of modules, managers, handlers, and services
func scan_runtime_node_map():
	var root_node = get_tree().root
	if root_node:
		_build_categorized_map(root_node, categorized_map)
		save_categorized_map_to_file(categorized_map, output_file_runtime_node_map)
	else:
		print("No root node found.")

func _build_categorized_map(node: Node, categorized_map: Dictionary):
	for child in node.get_children():
		if _is_module(child.name):
			var module_name = child.name
			_process_module_nodes(child, categorized_map, module_name)
		else:
			_build_categorized_map(child, categorized_map)

# Processes the nodes within the module and creates entries only for non-empty categories
func _process_module_nodes(module_node: Node, categorized_map: Dictionary, module_name: String):
	var manager_nodes = []
	var service_nodes = []
	var handler_nodes = []

	for child in module_node.get_children():
		if _is_manager(child.name):
			manager_nodes.append(child)
		elif _is_service(child.name):
			service_nodes.append(child)
		elif _is_handler(child.name):
			handler_nodes.append(child)

	if not manager_nodes.is_empty():
		categorized_map[module_name + "Manager"] = {}
		for manager in manager_nodes:
			_add_children_to_category(manager, categorized_map[module_name + "Manager"])
			_process_manager(manager, categorized_map)
	if not service_nodes.is_empty():
		categorized_map[module_name + "Service"] = {}
		for service_group in service_nodes:
			_add_grandchildren_to_category(service_group, categorized_map[module_name + "Service"])

	if not handler_nodes.is_empty():
		categorized_map[module_name + "Handler"] = {}
		for handler in handler_nodes:
			_add_children_to_category(handler, categorized_map[module_name + "Handler"])

func _process_manager(manager_node: Node, categorized_map: Dictionary):
	var handler_nodes = {}
	
	for manager in manager_node.get_children():
		var manager_name = manager.name
		print("manager found: ", manager_name)
		handler_nodes[manager_name] = []
		
		for child in manager.get_children():
			if _is_handler(child.name):
				print("handler found: ", child.name)
				handler_nodes[manager_name].append(child)

	for manager_name in handler_nodes:
		var handlers = handler_nodes[manager_name]
		if not handlers.is_empty():
			categorized_map[manager_name + "Handler"] = {}
			for handler in handlers:
				_add_children_to_category(handler, categorized_map[manager_name + "Handler"])


# Adds children to the corresponding category
func _add_children_to_category(parent: Node, category: Dictionary):
	for child in parent.get_children():
		category[child.name] = {
			"path_tree": str(child.get_path()),
			"cache": true
		}

# Adds grandchildren to the corresponding category
func _add_grandchildren_to_category(service_group: Node, category: Dictionary):
	for service_subgroup in service_group.get_children():
		for service in service_subgroup.get_children():
			category[service.name] = {
				"path_tree": str(service.get_path()),
				"cache": true
			}

# Checks if a node is a module
func _is_module(node_name: String) -> bool:
	return node_name.ends_with("Module")

# Checks if a node is a manager
func _is_manager(node_name: String) -> bool:
	return node_name.ends_with("Manager")

# Checks if a node is a handler
func _is_handler(node_name: String) -> bool:
	return node_name.ends_with("Handler")

# Checks if a node is a service
func _is_service(node_name: String) -> bool:
	return node_name.ends_with("Service")

# Saves the categorized structure to a file, with clearly separated groups for managers, handlers, and services
func save_categorized_map_to_file(categorized_map: Dictionary, file_path: String):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file != null:
		file.store_line("extends Node\n")

		for group_name in categorized_map.keys():
			file.store_line("var " + group_name + " = {")
			for entry_name in categorized_map[group_name].keys():
				var entry = categorized_map[group_name][entry_name]
				file.store_line('    "' + entry_name + '": {')
				file.store_line('        "path_tree": "' + entry["path_tree"] + '",')
				file.store_line('        "cache": ' + str(entry["cache"]))
				file.store_line('    },')
			file.store_line("}\n")
		file.close()
		print("Categorized node structure successfully saved to file:", file_path)
	else:
		print("Error opening file for writing:", file_path)
