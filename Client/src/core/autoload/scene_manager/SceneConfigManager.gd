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
	"Mage": "res://shared/data/characters/players/mage/Mage.tscn",
	"Archer": "res://shared/data/characters/players/archer/Archer.tscn",
	"Knight": "res://shared/data/characters/players/knight/Knight.tscn",
}

func get_scene_path(scene_name: String) -> String:
	scene_name = scene_name
	if scene_cores.has(scene_name):
		return scene_cores[scene_name]
	if misc_scenes.has(scene_name):
		return misc_scenes[scene_name]
	if scene_levels.has(scene_name):
		return scene_levels[scene_name]
	if scene_players.has(scene_name):
		return scene_players[scene_name]
	else:
		print("Error: Scene name not found in config:", scene_name)
		return ""
