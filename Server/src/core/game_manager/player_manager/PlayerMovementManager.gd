# res://src/core/game_manager/player_manager/PlayerMovementManager.gd (Server)
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)

var enet_server_manager
var player_positions = {}
var is_initialized = false
var players = {}

func _ready():
	initialize()

func initialize():
	if is_initialized:
		print("PlayerMovement already initialized. Skipping.")
		return
	enet_server_manager = GlobalManager.GlobalNodeManager.get_node_from_config("network_meta_manager", "enet_server_manager")
	is_initialized = true

# Hält die Referenz zu den Spieler-Nodes
func add_player(peer_id: int, player_node: Node):
	if player_node:
		players[peer_id] = player_node
		print("Player added: ", peer_id, " -> ", player_node)
	else:
		print("Failed to add player for peer_id: ", peer_id, " - player_node is null")

func print_all_players():
	print("Current registered players: ", players)


# Prüfen, ob der Spieler-Node richtig hinzugefügt wurde
func get_player_character(peer_id: int) -> Node:
	var player_character = players.get(peer_id, null)
	if player_character == null:
		print("No player character found for peer_id: ", peer_id)
	return player_character



# Processes movement data and updates player positions
func process_received_data(peer_id: int, movement_data: Dictionary):
	print("Processing movement data for peer_id ", peer_id)  # Zeigt den empfangenen `peer_id`
	
	var new_position = movement_data.get("position", Vector2())
	var velocity = movement_data.get("velocity", Vector2())
	
	# Prüfen, ob der Spieler korrekt registriert wurde
	var player_character = get_player_character(peer_id)
	if player_character:
		player_character.global_position = new_position
		print("Updated position for player: ", peer_id, " to ", player_character.global_position)
	else:
		print("No player character found for peer_id: ", peer_id)
		print_all_players()  # Zeige alle registrierten Spieler zur Fehleranalyse an


# Validation logic for movement
func is_valid_movement(peer_id: int, new_position: Vector2, velocity: Vector2) -> bool:
	# Hier könnte Logik eingefügt werden, um die Bewegung zu validieren (z.B. Kollisionen prüfen)
	return true

# Synchronize movement with all clients
func sync_movement_with_clients(peer_id: int, position: Vector2, velocity: Vector2):
	var movement_data = {
		"peer_id": peer_id,
		"position": {"x": position.x, "y": position.y},
		"velocity": {"x": velocity.x, "y": velocity.y}
	}
	
	var json = JSON.new()
	var json_string = json.stringify(movement_data)
	
	if json_string == "":
		print("Failed to serialize movement data for peer: ", peer_id)
		return
	
	var packet = json_string.to_utf8_buffer()
	
	if enet_server_manager:
		# Check if there's a method to get connected peers or clients
		var connected_peers = get_connected_peers()  # Placeholder; ersetze dies mit der tatsächlichen Methode
		for other_peer_id in connected_peers:
			if other_peer_id != peer_id:
				var result = enet_server_manager.send_bytes(packet, other_peer_id)
				if result:
					print("Movement data sent successfully to peer: ", other_peer_id)
				else:
					print("Failed to send movement data to peer: ", other_peer_id)
	else:
		print("ENetServerManager is not initialized.")

# Placeholder function to retrieve connected peers
func get_connected_peers() -> Array:
	return []

# Handle removing player on disconnect
func remove_player(peer_id: int):
	player_positions.erase(peer_id)
	print("Player removed from movement tracking: ", peer_id)

# Utility function to retrieve all player data
func get_all_players_data() -> Dictionary:
	var data = {}
	for peer_id in player_positions.keys():
		data[peer_id] = player_positions[peer_id]
	return data
