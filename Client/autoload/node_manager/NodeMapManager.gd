# res://src/core/autoload/node_manager/NodeMapManager.gd
extends Node

# Load the map files
var global_manager_map = preload("res://autoload/map/GlobalManagerMap.gd").new()
var global_node_map = preload("res://autoload/map/GlobalNodeMap.gd").new()


# Manager instances and maps
var node_manager_name_and_paths = {}
var manager_instances = {}
var initialization_in_progress = false  # Prevent recursion
var combined_manager_maps = {}
var is_initialized = false  

# Initialisiere den Manager nur einmal
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

# Function to collect all manager maps into a single dictionary
func _collect_all_manager_maps() -> Dictionary:
	var all_manager_maps = {}
	all_manager_maps["GlobalManagerMap"] = global_manager_map.get_data()
	all_manager_maps["GlobalNodeMap"] = global_node_map.get_data()
	return all_manager_maps

# Attach map nodes as children
func _attach_map_nodes():
	for map_name in combined_manager_maps.keys():
		var map_node = Node.new()
		map_node.name = map_name
		map_node.set_meta("map_data", combined_manager_maps[map_name])
		add_child(map_node)
		# print("Node for ", map_name, " attached as child.")

# Function to get map data
func get_map_data(map_name: String) -> Dictionary:
	var map_node = get_node_or_null(map_name)
	if map_node:
		return map_node.get_meta("map_data", {})
	else:
		# print("Error: Map node ", map_name, " not found!")
		return {}
		
# Function to retrieve a node from the map (returns the actual Node)
func get_node_from_map(map_name: String, node_category: String, node_name: String) -> Node:
	var map_data = get_map_data(map_name)
	
	# Check if the map contains the node info
	if map_data.has(node_name):
		var node_info = map_data[node_name]
		var node_path = node_info.get("path_tree", "")
		
		if node_path != "":
			var node = get_node_or_null(node_path)
			if node != null:
				# print("Found node:", node_name, "in map:", map_name)
				return node
			else:
				# print("Error: Node not found at path ", node_path)
				pass
		else:
			# print("Error: Path not found for node ", node_name)
			pass
	else:
		# print("Error: Node info not found for ", node_name, " in map ", map_name)
		pass
	return null

# Function to retrieve a node from any map (without specifying map name)
func get_node_from_combined_maps(node_category: String, node_name: String) -> Node:
	for map_name in combined_manager_maps.keys():
		var map_data = get_map_data(map_name)
		if map_data.has(node_category):
			var node_info = map_data[node_category]
			
			if node_info.has(node_name):
				var node_info_data = node_info[node_name]
				var node_path = node_info_data.get("path_tree", "")
				
				if node_path != "":
					var node = get_node_or_null(node_path)
					if node != null:

						if node.has_method("get_meta"):
							# print("Node metadata: ", node.get_meta("info", "No metadata"))
							pass
						
						# Now return the node
						return node
					else:
						# print("Error: Node not found at path: ", node_path)
						pass
				else:
					# print("Error: Path not found for node: ", node_name)
					pass
			else:
				# print("Error: Node info not found for ", node_name, " in ", node_category)
				pass
		else:
			# print("Error: Node type ", node_category, " not found in map ", map_name)
			pass
			
	# If node was not found in any map
	# print("Error: Node info not found for ", node_name, " in any combined map")
	return null

# Function to reference entries from a specific map and store them in the target dictionary
func reference_map_entry(map_name: String, node_category: String, target: Dictionary):
	var map_data = get_map_data(map_name)
	# print("Map data for ", map_name, ": ", map_data)
	# Check if the map contains the given node_category (e.g., "network_meta_manager")
	if map_data.has(node_category):
		var node_category_data = map_data[node_category]

		# Iterate over the keys in the node_category_data and reference nodes
		for key in node_category_data.keys():
			# Skip if the entry is already referenced
			if target.has(key):
				# print("Skipping reference for already referenced: " + key)
				continue
			
			# Retrieve the node using the path from node_category_data
			var node_info = node_category_data[key]
			var node_path = node_info.get("path_tree", "")
			
			if node_path != "":
				var node = get_node_or_null(node_path)
				if node:
					target[key] = node
					# print("Referenced: " + key + " at path: " + node_path)
				else:
					# print("Error: Node not found at path: " + node_path)
					pass
			else:
				# print("Error: No path found for node: " + key)
				pass
	else:
		# print("Error: Node type ", node_category, " not found in map ", map_name)
		pass

# Function to retrieve data from any combined manager map
func get_combined_map_data(node_name: String) -> Dictionary:
	for map_name in combined_manager_maps.keys():
		var map_data = get_map_data(map_name)
		var result = search_nested_map(map_data, node_name)
		if result:
			return result
	# print("Error: Node info not found for ", node_name)
	return {}

func search_nested_map(nested_map: Dictionary, node_name: String) -> Dictionary:
	for key in nested_map.keys():
		var value = nested_map[key]
		if typeof(value) == TYPE_DICTIONARY:
			if value.has(node_name):
				return value[node_name]
			else:
				var result = search_nested_map(value, node_name)
				if result.size() > 0:
					return result
	return {}  # Rückgabe eines leeren Dictionarys, wenn nichts gefunden wird

# Optional: Print combined maps for debugging
func print_combined_maps():
	# print("Combined Manager Maps : ", combined_manager_maps)
	
	# Print out the keys of the combined manager maps
	if combined_manager_maps.size() > 0:
		# print("combined_manager_maps.keys(): ", combined_manager_maps.keys())
		# Dynamically loop through each map and print the keys within
		for map_name in combined_manager_maps.keys():
			var map_data = combined_manager_maps[map_name]
			if map_data:
				print(map_name, "keys: ", map_data.keys())
				pass
			else:
				print("Error: No data for map ", map_name)
				pass
	else:
		# print("Error: No combined maps found")
		pass
