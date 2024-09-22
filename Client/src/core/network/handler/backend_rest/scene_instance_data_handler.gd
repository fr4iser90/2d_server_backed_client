# scene_instance_data_handler (Client)
extends Node

var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var handler_name = "scene_instance_data_handler"
var is_initialized = false

# Initialize the handler
func initialize():
	if is_initialized:
		print("scene_instance_data_handler already initialized.")
		return
	
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true
	print("scene_instance_data_handler initialized.")

# Handle incoming instance data
func handle_packet(data: Dictionary):
	print("Handling instance data packet:", data)
	if data.has("scene_path") and data.has("players") and data.has("mobs") and data.has("npcs"):
		var scene_path = data["scene_path"]
		var players_data = data["players"]
		var mobs_data = data["mobs"]
		var npcs_data = data["npcs"]

		# Process the scene data
		print("Received scene path:", scene_path)
		_load_scene(scene_path)

		# Handle entities in the instance (players, mobs, NPCs)
		_process_entities("players", players_data)
		_process_entities("mobs", mobs_data)
		_process_entities("npcs", npcs_data)
	else:
		print("Invalid instance data received.")
		emit_signal("instance_data_failed", "Missing required fields")

# Load the scene based on the path
func _load_scene(scene_path: String):
	print("Loading scene:", scene_path)
	var scene = load(scene_path)
	if scene and scene is PackedScene:
		get_tree().root.add_child(scene.instantiate())
		print("Scene loaded successfully:", scene_path)
	else:
		print("Error loading scene:", scene_path)

# Process players, mobs, or NPCs data and emit a signal for each
func _process_entities(entity_type: String, entity_data: Array):
	for entity in entity_data:
		print("Processing entity of type", entity_type, "with data:", entity)
		emit_signal("entity_received", entity_type, entity)  # You can handle the entities further based on this signal
