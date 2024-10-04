extends Node

var scene_levels = {
    "spawn_room2": "res://shared/data/levels/test/spawn_room2.tscn",
    "sample_layout": "res://shared/data/levels/test/sample_layout.tscn",
    "spawn_room333": "res://shared/data/levels/test/spawn_room333.tscn",
    "Room": "res://shared/data/levels/test/Room.tscn",
    "spawn_room": "res://shared/data/levels/test/spawn_room.tscn",
}

var misc_scenes = {
    "Mage": "res://shared/data/characters/players/Mage.tscn",
    "Archer": "res://shared/data/characters/players/Archer.tscn",
    "Knight": "res://shared/data/characters/players/Knight.tscn",
    "npc_test": "res://shared/data/characters/NPC/npc_test.tscn",
    "enemy_test": "res://shared/data/characters/Enemies/enemy_test.tscn",
    "NetworkGameUDPENetPeerModule": "res:///network/module/network_game/game_udp/NetworkGameUDPENetPeerModule.tscn",
    "NetworkDatabaseMongoDBRESTModule": "res:///network/module/network_database/database_mongodb_rest/NetworkDatabaseMongoDBRESTModule.tscn",
    "NetworkDatabaseGodotWebsocketModule": "res:///network/module/network_database/database_godot_websocket/NetworkDatabaseGodotWebsocketModule.tscn",
    "UserSessionModule": "res:///user/module/user_session/UserSessionModule.tscn",
    "LoadingScene": "res:///game/module/loading_manager/LoadingScene.tscn",
    "GameWorldModule": "res:///game/module/GameWorldModule.tscn",
    "GameLevelModule": "res:///game/module/GameLevelModule.tscn",
    "GameNPCModule": "res:///game/module/GameNPCModule.tscn",
    "GamePlayerModule": "res:///game/module/GamePlayerModule.tscn",
    "ServerConsole": "res:///server/ServerConsole.tscn",
    "builder": "res:///server/builder.tscn",
    "CoreTree": "res:///server/CoreTree.tscn",
}

func get_scene_path(scene_name: String) -> String:
    scene_name = scene_name
    if scene_levels.has(scene_name):
        return scene_levels[scene_name]
    if misc_scenes.has(scene_name):
        return misc_scenes[scene_name]
    else:
        print("Error: Scene name not found in config:", scene_name)
        return ""
