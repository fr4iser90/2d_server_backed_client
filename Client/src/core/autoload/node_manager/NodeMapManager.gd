# res://src/core/autoload/node_manager/NodeMapManager.gd
extends Node

# Load the map files
var scene_manager_map = preload("res://src/core/autoload/map/node/NodeSceneManagerMap.gd").new()
var node_manager_map = preload("res://src/core/autoload/map/node/NodeManagerMap.gd").new()
var auth_manager_map = preload("res://src/core/autoload/map/node/NodeBackendManagerMap.gd").new()
var network_meta_manager_map = preload("res://src/core/autoload/map/node/NodeNetworkManagerMap.gd").new()
var backend_manager_map = preload("res://src/core/autoload/map/node/NodeBackendManagerMap.gd").new()
var game_manager_map = preload("res://src/core/autoload/map/node/NodeGameManagerMap.gd").new()
var network_handler_map = preload("res://src/core/autoload/map/handler/NetworkHandlerMap.gd").new()
var world_manager_map = preload("res://src/core/autoload/map/node/NodeGameManagerMap.gd").new()

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
	all_manager_maps["SceneManagerMap"] = scene_manager_map.scene_manager
	all_manager_maps["NodeManagerMap"] = node_manager_map.node_manager
	all_manager_maps["AuthManagerMap"] = auth_manager_map.auth_manager
	all_manager_maps["NetworkManagerMap"] = network_meta_manager_map.network_meta_manager
	all_manager_maps["BackendManagerMap"] = backend_manager_map.backend_manager
	all_manager_maps["GameManagerMap"] = game_manager_map.game_manager
	all_manager_maps["NetworkHandlerMap"] = network_handler_map.network_handler
	all_manager_maps["WorldManagerMap"] = world_manager_map.world_manager
	#print("All manager maps after collection:", all_manager_maps)
	return all_manager_maps

# Attach map nodes as children
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
		return map_node.get_meta("map_data", {})
	else:
		print("Error: Map node ", map_name, " not found!")
		return {}
		
# Function to retrieve a node from the map (returns the actual Node)
func get_node_from_map(map_name: String, node_type: String, node_name: String) -> Node:
	var map_data = get_map_data(map_name)

	# Check if the map contains the node info
	if map_data.has(node_name):
		var node_info = map_data[node_name]
		var node_path = node_info.get("path_tree", "")
		
		if node_path != "":
			var node = get_node_or_null(node_path)
			if node != null:
				#print("Found node:", node_name, "in map:", map_name)
				return node
			else:
				#print("Error: Node not found at path ", node_path)
				pass
		else:
			#print("Error: Path not found for node ", node_name)
			pass
	else:
		#print("Error: Node info not found for ", node_name, " in map ", map_name)
		pass
	return null

# Function to retrieve a node from any map (without specifying map name)
func get_node_from_combined_maps(node_type: String, node_name: String) -> Node:
	for map_name in combined_manager_maps.keys():
		var map_data = get_map_data(map_name)

		# Check if the map contains the node info
		if map_data.has(node_name):
			var node_info = map_data[node_name]
			var node_path = node_info.get("path_tree", "")

			if node_path != "":
				var node = get_node_or_null(node_path)
				if node != null:
					print("Found node: ", node_name, " in map: ", map_name)
					return node
				else:
					#print("Error: Node not found at path ", node_path)
					pass
			else:
				#print("Error: Path not found for node ", node_name)
				pass
	
	# If node was not found in any map
	#print("Error: Node info not found for ", node_name)
	return null

# Function to reference entries from a specific map and store them in the target dictionary
func reference_map_entry(map_name: String, node_type: String, target: Dictionary):
	var map_data = get_map_data(map_name)
	for key in map_data.keys():
		# Skip if the entry is already referenced
		if target.has(key):
			#print("Skipping reference for already referenced: " + key)
			continue
		
		var node = get_node_from_map(map_name, node_type, key)
		if node:
			target[key] = node
			print("Referenced: " + key)
		else:
			#print("Error: Could not reference " + key)
			pass

# Function to retrieve data from any combined manager map
func get_combined_map_data(node_name: String) -> Dictionary:
	for map_name in combined_manager_maps.keys():
		var map_data = get_map_data(map_name)

		# Check if the map contains the node info
		if map_data.has(node_name):
			var node_info = map_data[node_name]
			# Only return if node_info is a Dictionary
			if node_info is Dictionary:
				return node_info
			else:
				print("Warning: Node info for ", node_name, " is not a Dictionary in ", map_name)
				continue
	
	#print("Error: Node info not found for ", node_name, " in any combined manager map")
	return {}


# Optional: Print combined maps for debugging
func print_combined_maps():
	# Print out the combined manager maps
	print("Combined Manager Maps : ", combined_manager_maps)
	
	# Print out the keys of the combined manager maps
	if combined_manager_maps.size() > 0:
		print("combined_manager_maps.keys(): ", combined_manager_maps.keys())
		# Dynamically loop through each map and print the keys within
		for map_name in combined_manager_maps.keys():
			var map_data = combined_manager_maps[map_name]
			if map_data:
				print(map_name, "keys: ", map_data.keys())
			else:
				print("Error: No data for map ", map_name)
	else:
		print("Error: No combined maps found")


