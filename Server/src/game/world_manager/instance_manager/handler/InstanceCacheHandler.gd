# InstanceCacheHandler
extends Node

@onready var instance_manager = $"../.."

var full_instances = {}  # Store full instance data (players, mobs, npcs)
var minimal_instances = {}  # Store minimal player data for broadcasting
var player_instance_map = {}  # Maps peer_id to instance_key


# Get full instance data for internal use
func get_instance_data(instance_key: String) -> Dictionary:
	return full_instances.get(instance_key, {})

# Get minimal instance data for client broadcasting (without position/velocity)
func get_minimal_player_data(instance_key: String) -> Array:
	# Retrieve the instance data as a Dictionary (or an empty dictionary if not found)
	var instance_data = minimal_instances.get(instance_key, {})

	# Ensure 'players' key exists and contains an Array
	if instance_data.has("players"):
		return instance_data["players"] as Array
	else:
		return []  # Return an empty array if 'players' key is missing

# Get instance ID for a peer
func get_instance_id_for_peer(peer_id: int) -> String:
	return player_instance_map.get(peer_id, "")

# Find an available instance based on scene name
func get_available_instance(scene_name: String) -> String:
	var max_players = instance_manager.get_max_players_per_instance()
	for key in full_instances.keys():
		if full_instances[key]["scene_path"] == scene_name and full_instances[key]["players"].size() < max_players:
			return key
	return ""

# Create a new instance
func create_instance(scene_name: String) -> String:
	var instance_key = scene_name + ":" + str(full_instances.size() + 1)

	# Initialize the full instance data
	full_instances[instance_key] = {
		"scene_path": scene_name,
		"players": [],
		"mobs": [],
		"npcs": []
	}

	# Initialize the minimal instance data
	minimal_instances[instance_key] = {
		"players": []  # Prepare an empty array for minimal player data
	}

	print("Instance created with key:", instance_key)
	return instance_key

# Add a player to both full and minimal instance maps
func add_player_to_instance(instance_key: String, player_data: Dictionary):
	# Remove position and velocity from player_data
	var cleaned_player_data = player_data.duplicate()
	cleaned_player_data.erase("position")
	cleaned_player_data.erase("velocity")

	# Add full player data to the full_instances map
	full_instances[instance_key]["players"].append(cleaned_player_data)

	# Create and add minimal player data to minimal_instances map (without position/velocity)
	var minimal_data = {
		"peer_id": player_data["peer_id"],
		"name": player_data["character_data"].get("name", ""),
		"character_class": player_data["character_data"].get("character_class", ""),
		"level": player_data["character_data"].get("level", 1)
	}
	minimal_instances[instance_key]["players"].append(minimal_data)

	# Map the player to the instance for future lookups
	player_instance_map[player_data["peer_id"]] = instance_key
	print("Added player to instance:", instance_key, "with minimal data:", minimal_data)

