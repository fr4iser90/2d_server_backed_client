extends Node

var scene_cores = {
	"NetworkGameUDPENetPeerModule": "res://src/core/network/module/network_game/game_udp/NetworkGameUDPENetPeerModule.tscn",
	"NetworkDatabaseMongoDBRESTModule": "res://src/core/network/module/network_database/database_mongodb_rest/NetworkDatabaseMongoDBRESTModule.tscn",
	"NetworkDatabaseGodotWebsocketModule": "res://src/core/network/module/network_database/database_godot_websocket/NetworkDatabaseGodotWebsocketModule.tscn",
	"ServerConsole": "res://src/core/server/scene/ServerConsole.tscn",
	"UserSessionModule": "res://src/core/server/scene/UserSessionModule.tscn",
	"builder": "res://src/core/server/scene/builder.tscn",
	"CoreTree": "res://src/core/server/scene/CoreTree.tscn",
}

var misc_scenes = {
	"LoadingScene": "res://src/game/module/loading_manager/LoadingScene.tscn",
	"GameWorldModule": "res://src/game/module/GameWorldModule.tscn",
	"GameLevelModule": "res://src/game/module/GameLevelModule.tscn",
	"GameNPCModule": "res://src/game/module/GameNPCModule.tscn",
	"GamePlayerModule": "res://src/game/module/GamePlayerModule.tscn",
	"Mage": "res://shared/data/characters/players/Mage.tscn",
	"Archer": "res://shared/data/characters/players/Archer.tscn",
	"Knight": "res://shared/data/characters/players/Knight.tscn",
	"npc_test": "res://shared/data/characters/NPC/npc_test.tscn",
	"enemy_test": "res://shared/data/characters/Enemies/enemy_test.tscn",
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
