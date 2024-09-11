extends Node2D
class_name DungeonRoom

@export var boss_room: bool = false

const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://Client/Characters/Enemies/SpawnExplosion.tscn")

const ENEMY_SCENES: Dictionary = {
	"FLYING_CREATURE": preload("res://Client/Characters/Enemies/Flying Creature/FlyingCreature.tscn"),
	"GOBLIN": preload("res://Client/Characters/Enemies/Goblin/Goblin.tscn"), 
	"SLIME_BOSS": preload("res://Client/Characters/Enemies/Bosses/SlimeBoss.tscn")
}

var num_enemies: int

@onready var tilemap: TileMap = get_node("TileMap2")
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	num_enemies = enemy_positions_container.get_child_count()


func _on_enemy_killed() -> void:
	if is_multiplayer_authority():  # Nur auf dem Server
		num_enemies -= 1
		if num_enemies == 0:
			_open_doors()


func _open_doors() -> void:
	for door in door_container.get_children():
		door.open()
	# Synchronisiere das Öffnen der Türen mit den Clients
	rpc("sync_open_doors")


@rpc
func sync_open_doors() -> void:
	# Clients öffnen die Türen synchron
	for door in door_container.get_children():
		door.open()


func _close_entrance() -> void:
	for entry_position in entrance.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position), 1, Vector2i.ZERO)
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 2, Vector2i.ZERO)
	# Synchronisiere das Schließen des Eingangs mit den Clients
	rpc("sync_close_entrance")


@rpc
func sync_close_entrance() -> void:
	# Clients schließen die Eingangstüren synchron
	for entry_position in entrance.get_children():
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position), 1, Vector2i.ZERO)
		tilemap.set_cell(0, tilemap.local_to_map(entry_position.position) + Vector2i.DOWN, 2, Vector2i.ZERO)


func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: CharacterBody2D
		if boss_room:
			enemy = ENEMY_SCENES.SLIME_BOSS.instantiate()
			num_enemies = 15
		else:
			if randi() % 2 == 0:
				enemy = ENEMY_SCENES.FLYING_CREATURE.instantiate()
			else:
				enemy = ENEMY_SCENES.GOBLIN.instantiate()
		enemy.position = enemy_position.position
		add_child(enemy)

		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.position = enemy_position.position
		add_child(spawn_explosion)
	# Synchronisiere das Spawnen von Gegnern mit den Clients
	rpc("sync_spawn_enemies")


@rpc
func sync_spawn_enemies() -> void:
	# Clients spawnen die Gegner synchron
	_spawn_enemies()


func _on_PlayerDetector_body_entered(_body: CharacterBody2D) -> void:
	if is_multiplayer_authority():  # Nur auf dem Server
		player_detector.queue_free()
		if num_enemies > 0:
			_close_entrance()
			_spawn_enemies()
		else:
			_close_entrance()
			_open_doors()
