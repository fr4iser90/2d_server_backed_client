extends Node

var scene_levels = {
	"spawn_room2": "res://shared/data/levels/test/spawn_room2.tscn",
	"spawn_room4": "res://shared/data/levels/test/spawn_room4.tscn",
	"sample_layout": "res://shared/data/levels/test/sample_layout.tscn",
	"spawn_room333": "res://shared/data/levels/test/spawn_room333.tscn",
	"Room": "res://shared/data/levels/test/Room.tscn",
	"spawn_room": "res://shared/data/levels/test/spawn_room.tscn",
}

var misc_scenes = {
	"Mage": "res://shared/data/characters/players/Mage.tscn",
	"Archer": "res://shared/data/characters/players/Archer.tscn",
	"Knight": "res://shared/data/characters/players/Knight.tscn",
	"DarkElf": "res://shared/data/characters/Enemies/Common/DarkElf.tscn",
	"CharacterData": "res://debugging/character/CharacterData.tscn",
	"UserSessionModule": "res://user/module/user_session/UserSessionModule.tscn",
	"GameWorldModule": "res://game/module/GameWorldModule.tscn",
	"GameLevelModule": "res://game/module/GameLevelModule.tscn",
	"GamePlayerModule": "res://game/module/GamePlayerModule.tscn",
}

var scene_cores = {
	"GameTree": "res://src/core/client/scene/tree/GameTree.tscn",
	"NetworkGameModule": "res://src/core/client/scene/tree/NetworkGameModule.tscn",
	"BuildClient": "res://src/core/client/scene/tree/BuildClient.tscn",
	"ClientMain": "res://src/core/client/scene/tree/ClientMain.tscn",
	"LauncherModule": "res://src/core/client/scene/tree/LauncherModule.tscn",
	"options_menu": "res://src/core/client/scene/menu/modular/options_menu.tscn",
	"login_menu": "res://src/core/client/scene/menu/modular/login_menu.tscn",
	"main_menu": "res://src/core/client/scene/menu/modular/main_menu.tscn",
	"character_menu": "res://src/core/client/scene/menu/modular/character_menu.tscn",
	"connection_menu": "res://src/core/client/scene/menu/modular/connection_menu.tscn",
}

var scene_players = {
	"PlayerMovementBody2D": "res://src/game/player_manager/player_movement_manager/PlayerMovementBody2D.tscn",
}

func get_scene_path(scene_name: String) -> String:
	scene_name = scene_name
	if scene_levels.has(scene_name):
		return scene_levels[scene_name]
	if misc_scenes.has(scene_name):
		return misc_scenes[scene_name]
	if scene_cores.has(scene_name):
		return scene_cores[scene_name]
	if scene_players.has(scene_name):
		return scene_players[scene_name]
	else:
		print("Error: Scene name not found in config:", scene_name)
		return ""
