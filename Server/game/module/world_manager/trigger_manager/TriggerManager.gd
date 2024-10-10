# TriggerManager
extends Node

# Managers
var player_movement_manager
var instance_manager

# Handlers for different trigger types
@onready var trigger_instance_change_handler = $Handler/TriggerInstanceChangeHandler
@onready var trigger_zone_change_handler = $Handler/TriggerZoneChangeHandler
@onready var trigger_room_change_handler = $Handler/TriggerRoomChangeHandler
@onready var trigger_event_handler = $Handler/TriggerEventHandler
@onready var trigger_trap_handler = $Handler/TriggerTrapHandler
@onready var trigger_objective_handler = $Handler/TriggerObjectiveHandler

# Trigger data
var trigger_data = {}
var peer_trigger_state = {}  # {peer_id: {trigger_name: is_inside}}

signal trigger_activated(peer_id: int, trigger_name: String, trigger_type: String)
signal trigger_deactivated(peer_id: int, trigger_name: String, trigger_type: String)

var is_initialized = false

func initialize():
	if is_initialized:
		return
	trigger_data = GlobalManager.SceneManager.get_trigger_data()  # Fetch trigger data globally
	instance_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "instance_manager")
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_player_module", "player_movement_manager")
	is_initialized = true

	if trigger_data.size() == 0:
		print("No trigger data found. Make sure SceneTriggerScanner ran.")
	else:
		print("TriggerManager initialized with trigger data.")

# Main loop to check for player positions relative to triggers
func _process(delta: float):
	if not is_initialized:
		initialize()
	# Get the list of all player IDs from the player movement manager
	var player_ids = player_movement_manager.get_all_player_ids()
	for peer_id in player_ids:
		var player_position = player_movement_manager.get_player_position(peer_id)
		_check_triggers_for_player(peer_id, player_position)

# Check player's position against all relevant triggers
func _check_triggers_for_player(peer_id: int, player_position: Vector2):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	var scene_triggers = get_triggers_for_instance(instance_key)

	if scene_triggers.size() == 0:
		return


	if not peer_trigger_state.has(peer_id):
		peer_trigger_state[peer_id] = {}

	# Check all triggers in the scene for entry/exit
	for trigger_type in scene_triggers.keys():
		var triggers = scene_triggers[trigger_type]
		for trigger_name in triggers.keys():
			var trigger_info = triggers[trigger_name]
			var trigger_rect = trigger_info["trigger_bounds"]  # Already precomputed as a Rect2

			var is_inside = trigger_rect.has_point(player_position)
			var was_inside = peer_trigger_state[peer_id].get(trigger_name, false)

			if is_inside and not was_inside:
				# The player has entered the trigger
				handle_trigger_entry(peer_id, trigger_name, trigger_type, player_position)
				peer_trigger_state[peer_id][trigger_name] = true  # Mark as inside the trigger
				send_packet_to_client(peer_id, trigger_name, trigger_type, "entered")
			elif not is_inside and was_inside:
				# The player has exited the trigger
				handle_trigger_exit(peer_id, trigger_name, trigger_type)
				peer_trigger_state[peer_id][trigger_name] = false  # Mark as outside the trigger
				send_packet_to_client(peer_id, trigger_name, trigger_type, "exited")
			# If the state hasn't changed, do nothing

# Handle player entering a trigger
func handle_trigger_entry(peer_id: int, trigger_name: String, trigger_type: String, position: Vector2):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	print("Handling trigger entry for peer:", peer_id, " in instance: ", instance_key)

	match trigger_type:
		"instance_change_trigger":
			trigger_instance_change_handler.handle_trigger_entry(peer_id, trigger_name, position)
		"zone_change_trigger":
			trigger_zone_change_handler.handle_trigger_entry(peer_id, trigger_name, position)
		"room_change_trigger":
			trigger_room_change_handler.handle_trigger_entry(peer_id, trigger_name, position)
		"event_trigger":
			trigger_event_handler.handle_trigger_entry(peer_id, trigger_name, position)
		"trap_trigger":
			trigger_trap_handler.handle_trigger_entry(peer_id, trigger_name, position)
		"objective_trigger":
			trigger_objective_handler.handle_trigger_entry(peer_id, trigger_name, position)
		_:
			print("Unknown trigger type:", trigger_type)

# Handle player exiting a trigger
func handle_trigger_exit(peer_id: int, trigger_name: String, trigger_type: String):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	print("Handling trigger exit for peer:", peer_id, " in instance: ", instance_key)

	match trigger_type:
		"instance_change_trigger":
			trigger_instance_change_handler.handle_trigger_exit(peer_id, trigger_name)
		"zone_change_trigger":
			trigger_zone_change_handler.handle_trigger_exit(peer_id, trigger_name)
		"room_change_trigger":
			trigger_room_change_handler.handle_trigger_exit(peer_id, trigger_name)
		"event_trigger":
			trigger_event_handler.handle_trigger_exit(peer_id, trigger_name)
		"trap_trigger":
			trigger_trap_handler.handle_trigger_exit(peer_id, trigger_name)
		"objective_trigger":
			trigger_objective_handler.handle_trigger_exit(peer_id, trigger_name)
		_:
			print("Unknown trigger type:", trigger_type)

# Retrieve triggers based on instance
func get_triggers_for_instance(instance_key: String) -> Dictionary:
	if not is_initialized:
		initialize()
	var scene_key = instance_key.split(":")[0]
	if trigger_data.has(scene_key):
		return trigger_data[scene_key]
	else:
		#print("No triggers found for scene:", scene_key)
		return {}

# Send packet data to the client about trigger events
func send_packet_to_client(peer_id: int, trigger_name: String, trigger_type: String, status: String):
	var packet_data = {
		"trigger_name": trigger_name,
		"trigger_type": trigger_type,
		"status": status
	}
	# GlobalManager.NetworkManager.send_packet_to_client(peer_id, packet_data)
