extends Node

var misc_scenes = {
    "menu_scene": "res://src/system/start_scene/menu_scene.tscn",
    "HealthPotion": "res://shared/data/Items/Consumables/HealthPotion.tscn",
    "Sword": "res://shared/data/Items/Weapons/Sword.tscn",
    "BattleAxe": "res://shared/data/Items/Weapons/BattleAxe.tscn",
    "Crossbow": "res://shared/data/Items/Weapons/Crossbow.tscn",
    "WarHammer": "res://shared/data/Items/Weapons/WarHammer.tscn",
    "Projectile": "res://shared/data/Items/Weapons/Projectile.tscn",
    "Arrow": "res://shared/data/Items/Weapons/Arrow.tscn",
    "Weapon": "res://shared/data/Items/Weapons/Weapon.tscn",
    "FlyingCreature": "res://shared/data/characters/Enemies/Common/Flying Creature/FlyingCreature.tscn",
    "ThrowableKnife": "res://shared/data/characters/Enemies/Common/Goblin/ThrowableKnife.tscn",
    "Goblin": "res://shared/data/characters/Enemies/Common/Goblin/Goblin.tscn",
    "SlimeBoss": "res://shared/data/characters/Enemies/Uniques/Slime/SlimeBoss.tscn",
    "Enemy": "res://shared/data/characters/Enemies/Enemy.tscn",
    "HitEffect": "res://shared/data/characters/Base/HitEffect.tscn",
    "Character": "res://shared/data/characters/Base/Character.tscn",
    "SpawnExplosion": "res://shared/data/characters/Base/Effects/SpawnExplosion.tscn",
}

var scene_cores = {
    "player_manager": "res://src/core/player_management/player_manager.tscn",
    "scene_loader": "res://src/core/scene_loader/scene_loader.tscn",
    "options_menu": "res://src/core/scene/menu/options_menu.tscn",
    "login_menu": "res://src/core/scene/menu/login_menu.tscn",
    "main_menu": "res://src/core/scene/menu/main_menu.tscn",
    "character_menu": "res://src/core/scene/menu/character_menu.tscn",
    "connection_menu": "res://src/core/scene/menu/connection_menu.tscn",
    "network_manager": "res://src/core/scene/network/network_manager.tscn",
    "NetworkHandler": "res://src/core/scene/network/NetworkHandler.tscn",
    "client_main": "res://src/core/scene/core/client_main.tscn",
    "CoreTree": "res://src/core/scene/core/CoreTree.tscn",
}

var scene_levels = {
    "SpawnRoom0": "res://shared/data/levels/Dungeons/Castle/Rooms/SpawnRoom0.tscn",
    "RoomWithWeapon": "res://shared/data/levels/Dungeons/Castle/Rooms/RoomWithWeapon.tscn",
    "Room2": "res://shared/data/levels/Dungeons/Castle/Rooms/Room2.tscn",
    "Room3": "res://shared/data/levels/Dungeons/Castle/Rooms/Room3.tscn",
    "Room4": "res://shared/data/levels/Dungeons/Castle/Rooms/Room4.tscn",
    "Stairs": "res://shared/data/levels/Dungeons/Castle/Rooms/Furniture and Traps/Stairs.tscn",
    "Torch": "res://shared/data/levels/Dungeons/Castle/Rooms/Furniture and Traps/Torch.tscn",
    "Spikes": "res://shared/data/levels/Dungeons/Castle/Rooms/Furniture and Traps/Spikes.tscn",
    "Door": "res://shared/data/levels/Dungeons/Castle/Rooms/Furniture and Traps/Door.tscn",
    "SlimeBossRoom": "res://shared/data/levels/Dungeons/Castle/Rooms/SlimeBossRoom.tscn",
    "SpawnRoom1": "res://shared/data/levels/Dungeons/Castle/Rooms/SpawnRoom1.tscn",
    "Room1": "res://shared/data/levels/Dungeons/Castle/Rooms/Room1.tscn",
    "RoomWithWeapon0": "res://shared/data/levels/Dungeons/Castle/Rooms/RoomWithWeapon0.tscn",
    "SpecialRoom1": "res://shared/data/levels/Dungeons/Castle/Rooms/SpecialRoom1.tscn",
    "Room0": "res://shared/data/levels/Dungeons/Castle/Rooms/Room0.tscn",
    "EndRoom0": "res://shared/data/levels/Dungeons/Castle/Rooms/EndRoom0.tscn",
    "Room": "res://shared/data/levels/Dungeons/Castle/Rooms/Room.tscn",
    "SpecialRoom0": "res://shared/data/levels/Dungeons/Castle/Rooms/SpecialRoom0.tscn",
    "spawn_room_2": "res://shared/data/levels/spawn/test/spawn_room_2.tscn",
    "spawn_room": "res://shared/data/levels/spawn/test/spawn_room.tscn",
}

var scene_players = {
    "mage": "res://shared/data/characters/players/mage/mage.tscn",
    "archer": "res://shared/data/characters/players/archer/archer.tscn",
    "knight": "res://shared/data/characters/players/knight/knight.tscn",
}

func get_scene_path(scene_name: String) -> String:
    scene_name = scene_name
    if misc_scenes.has(scene_name):
        return misc_scenes[scene_name]
    if scene_cores.has(scene_name):
        return scene_cores[scene_name]
    if scene_levels.has(scene_name):
        return scene_levels[scene_name]
    if scene_players.has(scene_name):
        return scene_players[scene_name]
    else:
        print("Error: Scene name not found in config:", scene_name)
        return ""
