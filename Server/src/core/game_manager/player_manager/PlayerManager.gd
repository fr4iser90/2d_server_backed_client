# res://src/core/network/game_manager/player_manager/player_manager.gd
extends Node

var spawn_manager
var user_manager
var instance_manager 
var player_movement_manager

var is_initialized = false  

func initialize():
	if is_initialized:
		return
	instance_manager = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager")
	spawn_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "spawn_manager")
	user_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "user_manager")
	player_movement_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "player_movement_manager")
	is_initialized = true

var player_data = {
	"peer_id": peer_id,  # Eindeutige ID des Spielers
	"authtoken": "auth_token", 
	"userid": "user_d",
	"character_name": "JohnDoe",  # Name des Charakters
	"character_class": "Warrior",  # Klasse des Charakters
	"inventory": [],  # Optional, falls es ein Inventarsystem gibt
	"instance_key": "scene_path:1",  # Aktuelle Instanz des Spielers
	"scene_name": "spawn_room",  # Aktuelle Szene des Spielers
	"spawn_point": Vector2(100, 100)  # Der Spawnpunkt in der Szene
}

# Handle player spawn logic
func handle_player_spawn(peer_id: int, scene_name: String, spawn_point: String, character_class: String, use_last_position: bool = false):
	print("PlayerManager: Handling player spawn for peer_id: ", peer_id)  # Der tatsächliche `peer_id` des Clients

	var spawn_position = spawn_manager.get_spawn_position(peer_id, scene_name, spawn_point, use_last_position)

	var character_data = user_manager.get_user_data(peer_id).get("selected_character", {})

	if character_data:
		var instance_key = instance_manager.create_instance(scene_name)
		if instance_key != "":
			var scene_instance = instance_manager.instances[instance_key]["scene_instance"]
			var player_character = instance_manager.spawn_player_character(character_data, scene_instance, character_class)
			print(player_character)
			if player_character:
				player_character.global_position = spawn_position
				print("Player spawned at position: ", spawn_position)
				
				# Füge den Spieler mit dem tatsächlichen `peer_id` hinzu
				player_movement_manager.add_player(peer_id, player_character)
				print("Player added to Movement2DManager: ", player_character)
				
				# Füge den Spieler zur Szene hinzu
				get_tree().current_scene.add_child(player_character)
				print("Player added to the scene.")
				
				# Debugging: Zeige alle Spieler im Movement2DManager an
				player_movement_manager.print_all_players()

			else:
				print("Error: Player character could not be spawned.")
		else:
			print("Error: Could not create instance for scene_name: ", scene_name)
	else:
		print("Error: No character data found for peer_id: ", peer_id)



# Example function to clear the last known position when a player logs out
func handle_player_logout(peer_id: int):
	spawn_manager.clear_last_known_position(peer_id)
	print("Player logged out, last known position cleared.")


