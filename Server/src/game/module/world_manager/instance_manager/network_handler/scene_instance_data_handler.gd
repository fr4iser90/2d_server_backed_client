# scene_instance_data_handler (Server)
extends Node

var enet_server_manager
var instance_manager
var handler_name = "scene_instance_data_handler"
var is_initialized = false

# Initialize the handler
func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")  # Get instance manager node
	instance_manager.connect("instance_created", Callable(self, "_on_instance_created"))
	instance_manager.connect("instance_assigned", Callable(self, "_on_instance_assigned"))
	is_initialized = true
	print("scene_instance_data_handler initialized.")

# Handle the 'instance_created' signal
func _on_instance_created(instance_key: String):
	#print("Instance created with key: ", instance_key)
	pass
	
# Handle the 'instance_assigned' signal
func _on_instance_assigned(peer_id: int, instance_key: String):
	print("Instance assigned to peer:", peer_id, "with instance key:", instance_key)
	
	# Send instance data to the new client
	send_instance_data_to_client(peer_id)
	
	# Benachrichtige alle anderen Spieler in der Instanz über den neuen Spieler
	var instance_data = instance_manager.get_instance_data(instance_key)
	if instance_data:
		for player_data in instance_data["players"]:
			var other_peer_id = player_data["peer_id"]
			if other_peer_id != peer_id:
				# Sende neue Spielerdaten an bestehende Spieler
				
				var new_player_packet = {
					"players": player_data
				}
				print("new_player_packet :", new_player_packet)
				
				enet_server_manager.send_packet(other_peer_id, handler_name, new_player_packet)

				# Sende bestehende Spieler an den neuen Spieler
				var existing_player_packet = {
					"existing_player": instance_data["players"]
				}
				enet_server_manager.send_packet(peer_id, handler_name, existing_player_packet)

# Handle incoming packets from the client
func handle_packet(packet: Dictionary, peer_id: int):
	if packet.has("request") and packet["request"] == "update_instance_data":
		send_instance_data_to_client(peer_id)
		
# Handle sending scene and instance data to a new player
func send_instance_data_to_client(peer_id: int):
	#print("Preparing to send instance data to peer_id:", peer_id)
	
	# Get the instance_id for the peer_id
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	if instance_key != "":
		# Fetch minimal data for this instance
		var minimal_player_data = instance_manager.get_minimal_player_data(instance_key)
		var full_instance_data = instance_manager.get_instance_data(instance_key)

		if full_instance_data.has("scene_path"):
			# Send only minimal player data, but full dataa for mobs and NPCs
			var packet_data = {
				"players": minimal_player_data,
				"mobs": full_instance_data["mobs"],
				"npcs": full_instance_data["npcs"]
			}

			# Dispatch the packet to the client
			#print("Sending instance data to peer_id:", peer_id, "with data:", packet_data)
			enet_server_manager.send_packet(peer_id, handler_name, packet_data)
		else:
			print("Error: Invalid instance data for instance key:", instance_key)
	else:
		print("Error: No instance found for peer_id:", peer_id)
