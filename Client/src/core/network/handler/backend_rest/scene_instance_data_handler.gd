# scene_instance_data_handler (Client)
extends Node

signal entity_received(entity_type: String, entity_data: Dictionary)

var enet_client_manager = null
var channel_manager = null
var packet_manager = null

@onready var instance_entity_node_manager = $"../../Handler/InstanceEntityNodeManager"

var handler_name = "scene_instance_data_handler"
var is_initialized = false
var request_timer: Timer  # Timer, um regelmäßig Daten vom Server anzufordern

# Initialize the handler
func initialize():
	if is_initialized:
		print("scene_instance_data_handler already initialized.")
		return
	
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	connect("entity_received", Callable(instance_entity_node_manager, "_on_entity_received"))
	
	# Timer initialisieren
	request_timer = Timer.new()
	request_timer.set_wait_time(2.0)  # Anfrage alle 2 Sekunden
	request_timer.set_autostart(true)
	request_timer.connect("timeout", Callable(self, "_request_data_update"))
	add_child(request_timer)  # Timer zum Node hinzufügen, damit er funktioniert
	
	is_initialized = true
	print("scene_instance_data_handler initialized.")

# Timer Funktion, um regelmäßig neue Daten vom Server anzufordern
func _request_data_update():
	print("Requesting instance data update from server...")
	var packet = {
		"request": "update_instance_data"
	}
	enet_client_manager.send_packet(handler_name, packet)

# Handle incoming instance data
func handle_packet(data: Dictionary):
	print("Handling instance data packet:", data)
	if data.has("players") and data.has("mobs") and data.has("npcs"):
		var players_data = data["players"]
		var mobs_data = data["mobs"]
		var npcs_data = data["npcs"]

		# Handle entities in the instance (players, mobs, NPCs)
		_process_entities("players", players_data)
		_process_entities("mobs", mobs_data)
		_process_entities("npcs", npcs_data)
	else:
		print("Invalid instance data received.")
		emit_signal("instance_data_failed", "Missing required fields")

# Process players, mobs, or NPCs data and emit a signal for each
func _process_entities(entity_type: String, entity_data: Array):
	for entity in entity_data:
		print("Processing entity of type ", entity_type, " with data: ", entity)
		emit_signal("entity_received", entity_type, entity)
