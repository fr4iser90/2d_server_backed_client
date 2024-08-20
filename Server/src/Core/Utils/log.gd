extends Node

# Dictionary to keep track of player data
var player_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("LogModule initialized")
	# You can initialize any necessary data here

# Log when a player connects
func log_player_connected(peer_id: int):
	player_data[peer_id] = {
		"status": "connected",
		"position": {
			"x": 0.0,
			"y": 0.0
		}
	}
	_log("Player connected: " + to_json({
		"peer_id": peer_id,
		"status": "connected",
		"position": player_data[peer_id]["position"]
	}))

# Log when a player disconnects
func log_player_disconnected(peer_id: int):
	if peer_id in player_data:
		player_data[peer_id]["status"] = "disconnected"
		_log("Player disconnected: " + to_json({
			"peer_id": peer_id,
			"status": "disconnected"
		}))
	else:
		_log("Unknown player disconnected: " + to_json({
			"peer_id": peer_id,
			"status": "disconnected",
			"error": "Unknown player"
		}))

# General logging function
func _log(message: String):
	print(message)

# Function to retrieve all current player data
func get_all_player_data() -> Dictionary:
	return player_data

# Convert data to JSON string
func to_json(data: Dictionary) -> String:
	var json = JSON.new()
	var json_string = json.stringify(data)
	if json_string == "":
		print("Failed to convert data to JSON")
	return json_string
