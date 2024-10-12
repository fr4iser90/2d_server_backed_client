# res://src/core/client/scene/tree/ClientMain.tscn (client)
extends Node

var channel_manager = null
var packet_manager = null
var network_module = null
var instance_manager = null
var enet_client_manager = null
var core_heartbeat_handler = null
var connection_handler = null
var disconnection_handler = null
var data_handler = null
var chat_messages_handler = null
var player_status_update_handler = null
var event_triggered_handler = null
var special_action_handler = null
var auth_login_handler = null
var char_fetch_handler = null
var char_select_handler = null
var spawn_manager = null
var character_manager = null
var movement_manager = null
var player_state_machine_manager = null
var user_session_manager = null
var player_manager = null
var is_initialized = false  

# Initialize the manager only once
func _ready():
	if is_initialized:
		return
	is_initialized = true
	
	# Initialize all necessary managers

	
# Function to initialize all necessary managers
func _initialize_managers():
	network_module = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkClientServerManager")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "UserSessionManager")
	
	player_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "PlayerManager")
	character_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "CharacterManager")
	spawn_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "SpawnManager")
	movement_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "PlayerMovementManager")
	player_state_machine_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "PlayerStateMachineManager")
		
	instance_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceManager")
	core_heartbeat_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "CoreHeartbeatService")
	connection_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "CoreConnectionService")
	disconnection_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "CoreDisconnectionService")
	data_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "DataService")
	chat_messages_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "ChatMessageService")
	player_status_update_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "PlayerStatusUpdateService")
	event_triggered_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "EventTriggeredService")
	special_action_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "SpecialActionService")
	auth_login_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "UserLoginService")
	char_fetch_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "CharacterFetchService")
	char_select_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "CharacterSelectService")

# Initialize player and scene with provided character data and instance key
func initialize_player_and_scene(character_data: Dictionary, instance_key: String, peer_id: int):
	print("Initializing player and scene with character data")
	# Attach peer_id to character_data
	character_data["peer_id"] = peer_id
	# Load the scene and defer player spawning
	load_scene_from_server(character_data.current_area, character_data, instance_key)

	
func load_scene_from_server(current_area: String, character_data: Dictionary, instance_key: String):
	print("Loading scene from server: ", current_area)
	var scene_path = GlobalManager.SceneManager.get_scene_path(current_area)
	print("Scene path: ", current_area)

	# Load the scene
	var packed_scene = load(scene_path)
	if packed_scene == null:
		print("Error: Scene resource could not be loaded!")
		return

	# Instantiate the scene
	var scene_instance = packed_scene.instantiate()
	if scene_instance == null:
		print("Error: Scene instance could not be created!")
		return
		
	print("Scene instance successfully loaded: ", scene_instance, " under /root/ClientMain/scene_name")

	# Add the scene to ClientMain
	var client_main = get_node("/root/ClientMain")
	if client_main:
		client_main.add_child(scene_instance)
	else:
		print("Error: ClientMain node does not exist!")

	# Defer player spawning, pass instance_key along
	call_deferred("_deferred_spawn_player", character_data, instance_key)


# This function is called after the scene is loaded to spawn the player
func _deferred_spawn_player(character_data: Dictionary, instance_key: String):
	var client_main = get_node("/root/ClientMain")
	if client_main == null:
		print("ClientMain node not ready yet. Retrying.")
		call_deferred("_deferred_spawn_player", character_data, instance_key)
		return

	print("Scene is ready. Spawning player.", character_data)
	spawn_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "SpawnManager")
	spawn_manager.spawn_local_player(character_data)

