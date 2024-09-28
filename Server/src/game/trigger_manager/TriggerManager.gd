# TriggerManager.gd
extends Node

@onready var trigger_instance_change_handler = $Handler/Player/TriggerInstanceChangeHandler
@onready var trigger_zone_change_handler = $Handler/Player/TriggerZoneChangeHandler
@onready var trigger_room_change_handler = $Handler/Player/TriggerRoomChangeHandler
@onready var player_room_change_detector = $Handler/Player/PlayerRoomChangeDetector
@onready var trigger_event_handler = $Handler/Player/TriggerEventHandler
@onready var trigger_trap_handler = $Handler/Player/TriggerTrapHandler
@onready var trigger_objective_handler = $Handler/Player/TriggerObjectiveHandler
@onready var player_movement_manager = $"../Player/PlayerMovementManager"
@onready var instance_manager = $"../World/InstanceManager"

signal trigger_activated(peer_id: int, trigger_name: String, trigger_type: String)
signal trigger_deactivated(peer_id: int, trigger_name: String, trigger_type: String)  # For leaving the area

# This will scan scenes for detectors initially
#var scan_scenes_for_detectors = GlobalManager.SceneManager.get_detectors_for_scene(scene_name)

# Function to handle trigger entry detection based on player's position
func handle_trigger_entry(peer_id: int, trigger_name: String, trigger_type: String, position: Vector2):
	match trigger_type:
		"instance_change":
			trigger_instance_change_handler.handle_trigger(peer_id, trigger_name, position)
		"zone_change":
			trigger_zone_change_handler.handle_trigger(peer_id, trigger_name, position)
		"room_change":
			trigger_room_change_handler.handle_trigger(peer_id, trigger_name, position)
		"event":
			trigger_event_handler.handle_trigger(peer_id, trigger_name, position)
		"trap":
			trigger_trap_handler.handle_trigger(peer_id, trigger_name, position)
		"objective":
			trigger_objective_handler.handle_trigger(peer_id, trigger_name, position)
		_:
			print("Unknown trigger type:", trigger_type)

# Function to handle trigger exit detection
func handle_trigger_exit(peer_id: int, trigger_name: String, trigger_type: String):
	match trigger_type:
		"instance_change":
			trigger_instance_change_handler.handle_exit(peer_id, trigger_name)
		"zone_change":
			trigger_zone_change_handler.handle_exit(peer_id, trigger_name)
		"room_change":
			trigger_room_change_handler.handle_exit(peer_id, trigger_name)
		"event":
			trigger_event_handler.handle_exit(peer_id, trigger_name)
		"trap":
			trigger_trap_handler.handle_exit(peer_id, trigger_name)
		"objective":
			trigger_objective_handler.handle_exit(peer_id, trigger_name)
		_:
			print("Unknown trigger type:", trigger_type)

func get_triggers_for_instance(instance_key: String):
	print("instance_key :", instance_key)
	#var scene_name = get_scene_name_from_instance_key
	#var triggers_in_scene = GlobalManager.SceneManager.get_detectors_for_scene(scene_name)
	pass

# Called when a player enters a detector area
func _on_trigger_activated(peer_id: int, trigger_name: String, trigger_type: String):
	var player_position = player_movement_manager.get_player_position(peer_id)
	handle_trigger_entry(peer_id, trigger_name, trigger_type, player_position)
	# Notify the client about entering the trigger area
	send_packet_to_client(peer_id, trigger_name, trigger_type, "entered")

# Called when a player exits a detector area
func _on_trigger_deactivated(peer_id: int, trigger_name: String, trigger_type: String):
	handle_trigger_exit(peer_id, trigger_name, trigger_type)
	# Notify the client about leaving the trigger area
	send_packet_to_client(peer_id, trigger_name, trigger_type, "exited")

# Utility to send packet data to the client about trigger events
func send_packet_to_client(peer_id: int, trigger_name: String, trigger_type: String, status: String):
	var packet_data = {
		"trigger_name": trigger_name,
		"trigger_type": trigger_type,
		"status": status  # "entered" or "exited"
	}
	# Send packet to client (you'll need to implement this on the network layer)
	GlobalManager.NetworkManager.send_packet_to_client(peer_id, packet_data)
