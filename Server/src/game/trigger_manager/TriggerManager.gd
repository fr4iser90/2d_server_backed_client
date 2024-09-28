# TriggerManager.gd
extends Node

@onready var player_movement_manager = $"../Player/PlayerMovementManager"
var instance_manager 

# Store the trigger data after scanning
var trigger_data = {}
var trigger_data_instance = {}

signal trigger_activated(peer_id: int, trigger_name: String, trigger_type: String)
signal trigger_deactivated(peer_id: int, trigger_name: String, trigger_type: String)

var is_initialized = false

func initialize():
	if is_initialized:
		return
	trigger_data = GlobalManager.SceneManager.get_trigger_data()  # Fetch trigger data globally
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	print("Trigger data fetched: ", trigger_data)
	is_initialized = true
	if trigger_data.size() == 0:
		print("No trigger data found. Make sure SceneTriggerScanner ran.")
	else:
		print("TriggerManager initialized with trigger data.")
		
# Called when a player enters a trigger area
func _on_trigger_activated(peer_id: int, trigger_name: String, trigger_type: String):
	var player_position = player_movement_manager.get_player_position(peer_id)
	handle_trigger_entry(peer_id, trigger_name, trigger_type, player_position)
	# Notify the client about entering the trigger area
	send_packet_to_client(peer_id, trigger_name, trigger_type, "entered")

# Called when a player exits a trigger area
func _on_trigger_deactivated(peer_id: int, trigger_name: String, trigger_type: String):
	handle_trigger_exit(peer_id, trigger_name, trigger_type)
	# Notify the client about leaving the trigger area
	send_packet_to_client(peer_id, trigger_name, trigger_type, "exited")

# Function to handle trigger entry detection based on player's position
func handle_trigger_entry(peer_id: int, trigger_name: String, trigger_type: String, position: Vector2):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)  # Get instance key for the player
	print("Handling trigger entry for peer:", peer_id, " in instance: ", instance_key)
	match trigger_type:
		"instance_change":
			print("Instance change trigger:", trigger_name)
		"zone_change":
			print("Zone change trigger:", trigger_name)
		"room_change":
			print("Room change trigger:", trigger_name)
		"event":
			print("Event trigger:", trigger_name)
		"trap":
			print("Trap trigger:", trigger_name)
		"objective":
			print("Objective trigger:", trigger_name)
		_:
			print("Unknown trigger type:", trigger_type)

# Function to handle trigger exit detection
func handle_trigger_exit(peer_id: int, trigger_name: String, trigger_type: String):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	print("Handling trigger exit for peer:", peer_id, " in instance: ", instance_key)
	# Add any additional handling for trigger exit if necessary.

# Store trigger data for instances
func store_trigger_data(instance_key: String, triggers: Array):
	if trigger_data.has(instance_key):
		print("Updating existing triggers for instance_key:", instance_key)
	else:
		print("Storing new triggers for instance_key:", instance_key)
	trigger_data[instance_key] = triggers

# Function to retrieve triggers based on instance
func get_triggers_for_instance(instance_key: String) -> Dictionary:
	if not is_initialized:
		initialize()
	# Split the instance_key at ':' to remove the number suffix
	var scene_key = instance_key.split(":")[0]  # Takes only the part before ':'
	print("trigger_data: ", trigger_data)
	# Check if the scene_key exists in the trigger_data
	if trigger_data.has(scene_key):
		var scene_triggers = trigger_data[scene_key]
		return scene_triggers  # Return the dictionary of categorized triggers
	else:
		print("No triggers found for scene:", scene_key)
		return {}

# Utility to send packet data to the client about trigger events
func send_packet_to_client(peer_id: int, trigger_name: String, trigger_type: String, status: String):
	var packet_data = {
		"trigger_name": trigger_name,
		"trigger_type": trigger_type,
		"status": status  # "entered" or "exited"
	}
	GlobalManager.NetworkManager.send_packet_to_client(peer_id, packet_data)
