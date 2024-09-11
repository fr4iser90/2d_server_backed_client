extends DungeonRoom

const WEAPONS: Array = [
	preload("res://Client/Weapons/WarHammer.tscn"), 
	preload("res://Client/Weapons/BattleAxe.tscn")
]

@onready var weapon_pos: Marker2D = get_node("WeaponPos")

func _ready() -> void:
	if is_multiplayer_authority():  # Nur auf dem Server
		_spawn_weapon()

func _spawn_weapon() -> void:
	var weapon: Node2D = WEAPONS[randi() % WEAPONS.size()].instantiate()
	weapon.position = weapon_pos.position
	weapon.set("on_floor", true)
	add_child(weapon)
	# Synchronisiere das Spawnen der Waffe mit den Clients
	rpc("sync_spawn_weapon", weapon.name, weapon.position)

@rpc
func sync_spawn_weapon(weapon_name: String, position: Vector2) -> void:
	# Waffe auf den Clients synchron spawnen
	var weapon_scene: PackedScene = WEAPONS.find(weapon_name)
	if weapon_scene != null:
		var weapon: Node2D = weapon_scene.instantiate()
		weapon.position = position
		weapon.set("on_floor", true)
		add_child(weapon)
