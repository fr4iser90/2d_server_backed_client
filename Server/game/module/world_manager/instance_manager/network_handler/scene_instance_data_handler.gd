# scene_instance_data_handler.gd (Server)
extends Node

var enet_server_manager
var instance_manager
var handler_name = "scene_instance_data_handler"
var is_initialized = false

# Initialisiere den Handler
func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")  # Hole den Instance Manager
	instance_manager.connect("instance_created", Callable(self, "_on_instance_created"))
	instance_manager.connect("instance_assigned", Callable(self, "_on_instance_assigned"))
	is_initialized = true
	print("scene_instance_data_handler initialized.")

# Handler für das Signal 'instance_created'
func _on_instance_created(instance_key: String):
	# Hier kannst du zusätzliche Logik hinzufügen, falls erforderlich
	pass

# Handler für das Signal 'instance_assigned'
func _on_instance_assigned(peer_id: int, instance_key: String):
	#print("Instance assigned to peer:", peer_id, "with instance key:", instance_key)
	
	# Sende Instanzdaten an den neuen Client
	send_instance_data_to_client(peer_id)
	
	# Benachrichtige alle anderen Spieler in der Instanz über den neuen Spieler
	var instance_data = instance_manager.get_instance_data(instance_key)
	if instance_data:
		var new_player_data = null
		# Finde die Daten des neuen Spielers
		for player_data in instance_data["players"]:
			if player_data["peer_id"] == peer_id:
				new_player_data = player_data
				break

		if new_player_data:
			for player_data in instance_data["players"]:
				var other_peer_id = player_data["peer_id"]
				if other_peer_id != peer_id:
					# Sende neue Spielerdaten an bestehende Spieler
					var new_player_packet = {
						"players": [new_player_data]  # Als Array senden für Konsistenz
					}
					enet_server_manager.send_packet(other_peer_id, handler_name, new_player_packet)

			# Sende bestehende Spielerdaten an den neuen Spieler
			var existing_players = []
			for player_data in instance_data["players"]:
				var existing_peer_id = player_data["peer_id"]
				if existing_peer_id != peer_id:
					existing_players.append(player_data)
			
			if existing_players.size() > 0:
				var existing_players_packet = {
					"players": existing_players
				}
				enet_server_manager.send_packet(peer_id, handler_name, existing_players_packet)
			else:
				print("No other players in instance to send to new peer:", peer_id)
		else:
			print("New player data not found in instance for peer_id:", peer_id)
	else:
		print("Instance data not found for instance_key:", instance_key)

# Handler für eingehende Pakete vom Client
func handle_packet(packet: Dictionary, peer_id: int):
	if packet.has("request") and packet["request"] == "update_instance_data":
		send_instance_data_to_client(peer_id)
		
# Sende die Szene- und Instanzdaten an einen Client
func send_instance_data_to_client(peer_id: int):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	
	if instance_key != "":
		var full_instance_data = instance_manager.get_instance_data(instance_key)

		if full_instance_data.has("scene_path"):
			# Only send relevant player data (exclude sensitive info)
			var players_minimal_data = []

			for player in full_instance_data["players"]:
				#print(full_instance_data["players"])
				
				players_minimal_data.append({
					"peer_id": player["peer_id"],
					"name": player["character_data"]["name"],                # Send only character name
					"character_class": player["character_data"]["character_class"],  # Class of character
					"position": player["character_data"]["position"]         # Position in the game world
				})

			# Construct the packet
			var packet_data = {
				"players": players_minimal_data,         # Send filtered player data
				"mobs": full_instance_data["mobs"],      # Full mob data if needed
				"npcs": full_instance_data["npcs"]       # Full NPC data
			}

			# Dispatch the packet to the client
			enet_server_manager.send_packet(peer_id, handler_name, packet_data)
			#print("Instance data sent to peer_id:", peer_id, "with filtered data:", packet_data)
		else:
			print("Error: Invalid instance data for instance key:", instance_key)
	else:
		print("Error: No instance found for peer_id:", peer_id)
