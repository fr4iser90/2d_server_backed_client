extends Node

var scene_cores = {
	"GameTree": "res://src/core/client/scene/tree/GameTree.tscn",
	"NetworkTree": "res://src/core/client/scene/tree/NetworkTree.tscn",
	"UserTree": "res://src/core/client/scene/tree/UserTree.tscn",
	"BuildClient": "res://src/core/client/scene/tree/BuildClient.tscn",
	"CoreTree": "res://src/core/client/scene/tree/CoreTree.tscn",
	"ClientMain": "res://src/core/client/scene/tree/ClientMain.tscn",
	"LauncherTree": "res://src/core/client/scene/tree/LauncherTree.tscn",
	"options_menu": "res://src/core/client/scene/menu/modular/options_menu.tscn",
	"login_menu": "res://src/core/client/scene/menu/modular/login_menu.tscn",
	"main_menu": "res://src/core/client/scene/menu/modular/main_menu.tscn",
	"character_menu": "res://src/core/client/scene/menu/modular/character_menu.tscn",
	"connection_menu": "res://src/core/client/scene/menu/modular/connection_menu.tscn",
}

var misc_scenes = {
	"PlayerMovementBody2D": "res://src/game/player_manager/player_movement_manager/PlayerMovementBody2D.tscn",
	"Mage": "res://shared/data/characters/players/Mage.tscn",
	"Archer": "res://shared/data/characters/players/Archer.tscn",
	"Knight": "res://shared/data/characters/players/Knight.tscn",
	"DarkElf": "res://shared/data/characters/Enemies/Common/DarkElf.tscn",
}

var scene_levels = {
	"spawn_room2": "res://shared/data/levels/test/spawn_room2.tscn",
	"sample_layout": "res://shared/data/levels/test/sample_layout.tscn",
	"spawn_room333": "res://shared/data/levels/test/spawn_room333.tscn",
	"Room": "res://shared/data/levels/test/Room.tscn",
	"spawn_room": "res://shared/data/levels/test/spawn_room.tscn",
}

func get_scene_path(scene_name: String) -> String:
	scene_name = scene_name
	if scene_cores.has(scene_name):
		return scene_cores[scene_name]
	if misc_scenes.has(scene_name):
		return misc_scenes[scene_name]
	if scene_levels.has(scene_name):
		return scene_levels[scene_name]
	else:
		print("Error: Scene name not found in config:", scene_name)
		return ""
