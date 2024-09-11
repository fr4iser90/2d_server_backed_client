# res://src/core/client_main.gd (client)
extends Node

var global_channel_map = null
var channel_manager = null
var packet_manager = null
var	network_manager = null
var	enet_client_manager = null
var	heartbeat_handler = null
var	connection_handler = null
var	disconnection_handler = null
var	data_handler = null
var	chat_messages_handler = null
var	player_status_update_handler = null
var	event_triggered_handler = null
var	special_action_handler = null
var	backend_login_handler = null
var	backend_character_handler = null
var	backend_character_select_handler = null
var	spawn_manager = null
var	user_manager = null
var	character_manager = null
var	movement_manager = null
var is_initialized = false  

# Initialisiere den Manager nur einmal
func _ready():
	if is_initialized:
		return
	is_initialized = true
	network_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	global_channel_map = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "global_channel_map")
	
	user_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "user_manager")
	character_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "character_manager")
	spawn_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "spawn_manager")
	movement_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "movement_manager")
			
	
	heartbeat_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "heartbeat_handler")
	connection_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "connection_handler")
	disconnection_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "disconnection_handler")
	data_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "data_handler")
	chat_messages_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "chat_messages_handler")
	player_status_update_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "player_status_update_handler")
	event_triggered_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "event_triggered_handler")
	special_action_handler = GlobalManager.GlobalNodeManager.get_cached_node("basic_handler", "special_action_handler")
	backend_login_handler = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_login_handler")
	backend_character_handler = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_character_handler")
	backend_character_select_handler = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_character_select_handler")
	load_scene_from_server()
	
func load_scene_from_server():
	print("Client main scene loaded")

	# Daten aus GlobalConfig abrufen
	var scene_name = GlobalManager.GlobalConfig.get_selected_scene_name()
	print("Scene: ", scene_name)
	var last_known_position = GlobalManager.GlobalConfig.get_last_known_position()

	# Wenn es eine letzte bekannte Position gibt, diese verwenden
	if last_known_position != Vector2(0, 0):
		spawn_manager.spawn_player_at_position(last_known_position)
		print("Player spawned at last known position: ", last_known_position)
	else:
		# Szene laden und dann Deferred Call verwenden, um sicherzustellen, dass die Szene vollständig geladen ist
		GlobalManager.GlobalSceneManager.load_scene(scene_name)
		# Deferred Call um den Player zu spawnen, nachdem die Szene geladen ist
		call_deferred("_deferred_spawn_player", scene_name)

func _deferred_spawn_player(scene_name: String):
	# Spawn-Punkt aus GlobalConfig abrufen
	GlobalManager.GlobalSceneManager.print_tree_structure()
	var spawn_point_name = GlobalManager.GlobalConfig.get_spawn_point()
	print("SpawnPoint: ", spawn_point_name)

	# Prüfe den Spawnpunkt in der geladenen Szene
	var spawn_position = GlobalManager.GlobalSceneManager.get_spawn_point(scene_name, spawn_point_name)
	if spawn_position != Vector2.ZERO:
		# Verwende die Position des gefundenen Spawn-Punkts
		spawn_manager.spawn_player_at_position(spawn_position, "knight")  # Add the second argument if needed
		print("Player spawned at spawnpoint: ", spawn_point_name)
	else:
		print("Spawn point node not found for: ", spawn_point_name)
		# Fallback zu einer Standardposition
		spawn_manager.spawn_player_at_position(Vector2(100, 100), "default")  # Add the second argument if needed
		print("Player spawned at fallback position")







	
