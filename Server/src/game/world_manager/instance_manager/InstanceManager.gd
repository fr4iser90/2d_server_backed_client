# res://src/core/game_manager/world_manager/InstanceManager.gd (Server)
extends Node

var instances = {}  # Stores all instances and their players
var instance_scene_map = {}  # Maps instance keys to scene names
var player_instance_map = {}  # Maps peer_id to instance_key

var max_players_per_instance = 20
signal instance_created(instance_key: String)
signal instance_assigned(peer_id: int, instance_key: String)

var is_initialized = false

# Initialize the InstanceManager
func initialize():
	if is_initialized:
		return
	is_initialized = true

# Handles player selection and assigns them to an instance
func handle_player_character_selected(peer_id: int, character_data: Dictionary):
	print("InstanceManager: Handling character selection for peer_id: ", peer_id)
	var scene_name = character_data.get("scene_name", "")
	var character_class = character_data.get("character_class", "")

	if scene_name != "" and character_class != "":
		# Assign the player to an instance
		var instance_key = assign_player_to_instance(scene_name, {
			"peer_id": peer_id,
			"character_data": character_data  # Store relevant data for the player
		})
		print("Player assigned to instance: ", instance_key)
		add_player_to_movement_manager(peer_id, character_data)
		emit_signal("instance_assigned", peer_id, instance_key)
		return instance_key
	else:
		print("Error: Invalid character data.")
		return ""

# Add player to PlayerMovementManager
func add_player_to_movement_manager(peer_id: int, player_data: Dictionary):
	var player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	if player_movement_manager:
		player_movement_manager.add_player(peer_id, player_data)
	else:
		print("Error: PlayerMovementManager not available.")
		
# Assigns the player to an appropriate instance or creates a new one
func assign_player_to_instance(scene_name: String, player_data: Dictionary) -> String:
	var instance_key = ""

	# Try to find an existing instance for the given scene that has available slots
	for key in instances.keys():
		if instances[key]["scene_path"] == scene_name and instances[key]["players"].size() < max_players_per_instance:
			instance_key = key
			break
	
	# Create a new instance if no suitable instance exists
	if instance_key == "":
		instance_key = create_instance(scene_name)

	# Assign the player to the found or newly created instance
	if instance_key != "":
		instances[instance_key]["players"].append(player_data)
		player_instance_map[player_data["peer_id"]] = instance_key
		emit_signal("instance_assigned", player_data["peer_id"], instance_key)
		return instance_key
	else:
		print("Error: No instance available to assign player.")
		return ""

# Creates a new instance for a given scene
func create_instance(scene_name: String) -> String:
	var instance_key = scene_name + ":" + str(instances.size() + 1)
	instances[instance_key] = {
		"scene_path": scene_name,
		"players": [],
		"mobs": [],
		"npcs": []
	}
	print("Instance created with key: ", instance_key)
	emit_signal("instance_created", instance_key)
	return instance_key

# Gets the instance ID for a given peer ID
func get_instance_id_for_peer(peer_id: int) -> String:
	if player_instance_map.has(peer_id):
		return player_instance_map[peer_id]
	else:
		print("No instance found for peer_id: ", peer_id)
		return ""

# Remove player from instance and update related managers
func remove_player_from_instance(peer_id: int):
	var instance_key = player_instance_map.get(peer_id, "")
	if instance_key != "":
		instances[instance_key]["players"].erase(peer_id)
		player_instance_map.erase(peer_id)
		print("Player removed from instance: ", instance_key)
	else:
		print("Error: No instance found for peer_id: ", peer_id)

# Get instance data for a given instance key
func get_instance_data(instance_key: String) -> Dictionary:
	if instances.has(instance_key):
		return instances[instance_key]
	else:
		print("Error: Instance not found for key:", instance_key)
		return {}

# Collect minimal data for players in the instance
func get_minimal_player_data(instance_key: String) -> Array:
	var minimal_data = []
	for player_data in instances[instance_key]["players"]:
		var player_id = player_data["peer_id"]
		var character_data = player_data["character_data"]
		minimal_data.append({
			"peer_id": player_id,
			"position": character_data.get("last_known_position", Vector2.ZERO),
			"scene_name": character_data.get("scene_name", ""),
			"appearance": character_data.get("appearance", {})  # Optional appearance info
		})
	return minimal_data
