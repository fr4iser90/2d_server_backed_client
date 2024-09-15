extends Node

var enet_server_manager
var handler_name = "movement_player_sync_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_node_from_config("network_meta_manager", "enet_server_manager")
	is_initialized = true

# Handhabt eingehende Pakete und verteilt Bewegungsdaten an Spieler in der Instanz
# Ändern wir peer_id zu instance_id, weil wir mit Instanzen arbeiten
func handle_packet(data: Dictionary, instance_id: String):
	var player_movement_manager = GlobalManager.NodeManager.get_node_from_config("game_manager", "player_movement_manager")
	
	if player_movement_manager:
		print("Synchronizing player positions in instance:", instance_id)
		player_movement_manager.sync_positions_with_clients_in_instance(instance_id)
	else:
		print("PlayerMovementManager not found.")
