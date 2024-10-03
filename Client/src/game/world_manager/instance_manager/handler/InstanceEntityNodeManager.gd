# res://src/core/client/scene/tree/InstanceEntityNodeManager.gd
extends Node
var last_sync_time = {}
var sync_interval = 0.03  # 30 ms sync interval
var smooth_factor = 0.1  # Adjust for smoother or faster interpolation
var entity_nodes = {}  # Stores nodes by entity ID and type (players, mobs, NPCs)
var is_initialized = false
@onready var scene_instance_data_handler = $"../../NetworkHandler/SceneInstanceDataHandler"

# Initialize instance manager
func initialize():
	if is_initialized:
		print("EntityManager already initialized. Skipping initialization.")
		return
	is_initialized = true
	print("InstanceEntityNodeManager initialized.")
	
# Handle entity_received signal
func _on_entity_received(entity_type: String, entity_data: Dictionary):
	print("Received entity signal for ", entity_type, " with data: ", entity_data)
	var entity_id = entity_data.get("peer_id", -1)  # Assuming "peer_id" is the unique identifier
	if entity_id != -1:
		create_entity_node(entity_type, entity_id, entity_data)
	else:
		print("Error: Invalid entity data received, missing peer_id.")
		
# Create an entity node (generalized for players, mobs, and NPCs)
func create_entity_node(entity_type: String, entity_id: int, entity_data: Dictionary):
	if entity_id == GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager").get_peer_id():
		print("Skipping entity creation for local player to avoid duplicate spawn.")
		return
	if entity_nodes.has(entity_id):
		print("Entity node for ID: ", entity_id, " already exists. Skipping creation.")
		return  # Do not create the entity again
	
	# Retrieve character-related data from the entity_data
	var character_class = entity_data.get("character_class")
	var scene_path = GlobalManager.SceneManager.get_scene_path(character_class)
	print("Resolved Character path: ", scene_path)
	# Fetch the scene name correctly	
	# Load the entity scene and instantiate it
	var scene = load(scene_path)
	if scene and scene is PackedScene:
		var entity_node = scene.instantiate()
		var position = entity_data.get("position", "")  # Start by retrieving position, expecting a string like "(101, 443)".

		# Check if position is a string and convert it to Vector2 if necessary
		if typeof(position) == TYPE_STRING and position != "":
			# Remove parentheses and split the string by comma and space
			var position_list = position.replace("(", "").replace(")", "").split(", ")
			
			# Ensure the list contains two elements and convert to Vector2
			if position_list.size() == 2:
				position = Vector2(position_list[0].to_float(), position_list[1].to_float())
			else:
				position = Vector2.ZERO  # Fallback if conversion fails
		else:
			# If position isn't a string, use the fallback Vector2.ZERO
			position = Vector2.ZERO

		# Now, assign the parsed or fallback position
		entity_node.global_position = position
		entity_node.set_meta("character_class", character_class)


		# Add entity node to the scene tree and track it
		get_tree().root.add_child(entity_node)
		entity_nodes[entity_id] = entity_node
		print("Successfully created entity node for ", entity_type, " with ID: ", entity_id)
	else:
		print("Error: Failed to load entity scene for ", entity_type, " with ID: ", entity_id, ". Scene path: ", scene_path)


# Update entity position
func update_entity_position(entity_id: int, position: Vector2, velocity: Vector2):
	#var current_time = Time.get_ticks_msec() / 1000.0  # Get time in seconds
	# Check rate limiting
	#if last_sync_time.has(entity_id) and current_time - last_sync_time[entity_id] < sync_interval:
	#	return  # Skip this update if it's too soon
	#last_sync_time[entity_id] = current_time
	
	print("Updating position for entity ID: ", entity_id, " to position: ", position, " with velocity: ", velocity)
	if entity_nodes.has(entity_id):
		var entity_node = entity_nodes[entity_id]
		entity_node.global_position = entity_node.global_position.lerp(position, smooth_factor)
		print("Successfully updated position for entity ID: ", entity_id)
	else:
		print("Error: No entity found for ID: ", entity_id)

# Remove entity node
func remove_entity_node(entity_id: int):
	print("Removing entity node for ID: ", entity_id)
	if entity_nodes.has(entity_id):
		var entity_node = entity_nodes[entity_id]
		entity_node.queue_free()
		entity_nodes.erase(entity_id)
		print("Successfully removed entity node for ID: ", entity_id)
	else:
		print("Error: No entity found for ID: ", entity_id)


