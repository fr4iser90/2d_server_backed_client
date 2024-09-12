# res://src/core/game_manager/player_manager/PlayerMovementManager.gd (Server)
extends Node

signal player_position_updated(peer_id: int, new_position: Vector2)

var enet_server_manager
var instance_manager
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
	instance_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "instance_manager")
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

# Im PlayerMovementManager.gd hinzufügen
func sync_positions_with_clients_in_instance(instance_id: String):
	# Nur Spieler innerhalb dieser Instanz synchronisieren
	var instance_manager = GlobalManager.GlobalNodeManager.get_node_from_config("game_manager", "instance_manager")
	var instance_data = instance_manager.instances.get(instance_id, null)
	if instance_data:
		var players_in_instance = instance_data["players"]
		for player_data in players_in_instance:
			var peer_id = player_data["peer_id"]
			var player_character = get_player_character(peer_id)
			if player_character:
				sync_movement_with_clients(peer_id, player_character.global_position, Vector2.ZERO)
	else:
		print("Instance not found: ", instance_id)

# Sendet die gesammelten Positionsdaten an alle Spieler in der Instanz
func sync_movement_with_clients(peer_id: int, position: Vector2, velocity: Vector2):
	var movement_data = {
		"peer_id": peer_id,
		"position": {"x": position.x, "y": position.y},
		"velocity": {"x": velocity.x, "y": velocity.y}
	}

	var handler_name = "player_movement_sync_handler"
	# Sende die Daten an alle Spieler in der Instanz
	var result = enet_server_manager.send_packet(peer_id, handler_name, movement_data)
	if result:
		print("Movement data sent to peer: ", peer_id)
	else:
		print("Failed to send movement data to peer: ", peer_id)

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
