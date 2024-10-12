# res://src/core/server/preset/database_godot/server_init_manager.gd
extends Node

var core_tree
var user_session_module
var game_player_module
var game_world_module
var game_level_module


signal all_managers_initialized

func _ready():
	call_deferred("_initialize")
	
func _initialize():

	# Initialisiere die Szenenbäume (Core, User, Game, Network)
#	core_tree = GlobalManager.SceneManager.load_scene("CoreTree")
	user_session_module = GlobalManager.SceneManager.put_scene_at_node("UserSessionModule", "User")
	game_player_module = GlobalManager.SceneManager.put_scene_at_node("GamePlayerModule", "Game")
	game_world_module = GlobalManager.SceneManager.put_scene_at_node("GameWorldModule", "Game")
	game_level_module = GlobalManager.SceneManager.put_scene_at_node("GameLevelModule", "Game")


	emit_signal("all_managers_initialized")
