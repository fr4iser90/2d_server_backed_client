extends Node

# Prefixes and Suffixes Definitions
const PREFIXES = ["service_", "module_", "manager_", "handler_", "controller_", "node_"]
const SUFFIXES = ["_service", "_manager", "_handler", "_controller", "_state", "_node"]

# Directory paths to map files (organized by node type)
var map_file_directories = {
	"manager": "res://src/core/autoload/map/manager/",
	"handler": "res://src/core/autoload/map/handler/",
	"service": "res://src/core/autoload/map/service/",
	"module": "res://src/core/autoload/map/module/",
	"scene": "res://src/core/autoload/map/scene/"
}

# Manager instances and maps
var node_manager_name_and_paths = {}
var manager_instances = {}
var initialization_in_progress = false  # Prevent recursion
var combined_manager_maps = {}
var is_initialized = false  

# Initialize Manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true

# Ready function to initialize
func _ready():
	if not is_initialized:
		initialize()
	combined_manager_maps = _collect_all_manager_maps()
	_attach_map_nodes()

# Dynamically collect all manager maps based on file paths and conventions
func _collect_all_manager_maps() -> Dictionary:
	var all_manager_maps = {}

	# Dynamically load map files from each folder based on node type
	for node_type in map_file_directories.keys():
		var directory_path = map_file_directories[node_type]
		var loaded_map = _load_map_files_from_directory(directory_path, node_type)
		all_manager_maps.merge(loaded_map)  # Merge loaded maps into the main dictionary

	return all_manager_maps

# Load map files from a specific directory
func _load_map_files_from_directory(directory_path: String, node_type: String) -> Dictionary:
	var map_data = {}
	var dir = DirAccess.open(directory_path)
	if dir != null and dir.list_dir_begin() == OK:
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".gd"):
				var map_name = _generate_map_name(file_name, node_type)
				var map_file_path = directory_path + file_name
				map_data[map_name] = load(map_file_path).new()
			file_name = dir.get_next()
		dir.list_dir_end()
	return map_data

# Generate map names based on file name and node type
func _generate_map_name(file_name: String, node_type: String) -> String:
	# Remove file extension to create a unique map name
	var base_name = file_name.get_basename()
	return base_name

# Attach map nodes as children dynamically
func _attach_map_nodes():
	for map_name in combined_manager_maps.keys():
		var map_node = Node.new()
		map_node.name = map_name
		map_node.set_meta("map_data", combined_manager_maps[map_name])
		add_child(map_node)
		print("Node for ", map_name, " attached as child.")

# Function to get map data
func get_map_data(map_name: String) -> Dictionary:
	var map_node = get_node_or_null(map_name)
	if map_node:
		var map_data = map_node.get_meta("map_data", {})  # Default to an empty Dictionary if no data
		if map_data is Dictionary:
			return map_data
		else:
			print("Error: map_data for ", map_name, " is not a Dictionary!")
			return {}
	else:
		print("Error: Map node ", map_name, " not found!")
		return {}

# Function to retrieve a node from the map (returns the actual Node)
func get_node_from_map(map_name: String, node_type: String, node_name: String) -> Node:
	var map_data = get_map_data(map_name)

	if map_data.has(node_name):
		var node_info = map_data[node_name]
		var node_path = node_info.get("path_tree", "")
		
		if node_path != "":
			var node = get_node_or_null(node_path)
			if node != null:
				return node
			else:
				print("Error: Node not found at path ", node_path)
	else:
		print("Error: Node info not found for ", node_name, " in map ", map_name)
	return null

# Function to retrieve a node from any map (without specifying map name)
func get_node_from_combined_maps(node_type: String, node_name: String) -> Node:
	for map_name in combined_manager_maps.keys():
		var map_data = get_map_data(map_name)
		if map_data.has(node_name):
			var node_info = map_data[node_name]
			var node_path = node_info.get("path_tree", "")

			if node_path != "":
				var node = get_node_or_null(node_path)
				if node != null:
					print("Found node: ", node_name, " in map: ", map_name)
					return node
				else:
					print("Error: Node not found at path ", node_path)
	return null

# Print combined maps for debugging
func print_combined_maps():
	print("Combined Manager Maps : ", combined_manager_maps)
	if combined_manager_maps.size() > 0:
		for map_name in combined_manager_maps.keys():
			var map_data = combined_manager_maps[map_name]
			if map_data:
				print(map_name, "keys: ", map_data.keys())
			else:
				print("Error: No data for map ", map_name)
	else:
		print("Error: No combined maps found")
