# NPCManager.gd
extends Node

# Handlers for different NPC operations
@onready var npc_spawning_handler = $Handler/NPCSpawningHandler
@onready var npc_state_handler = $Handler/NPCStateHandler
@onready var npc_movement_handler = $Handler/NPCMovementHandler
@onready var npc_health_handler = $Handler/NPCHealthHandler
@onready var npc_update_handler = $Handler/NPCUpdateHandler
@onready var npc_event_handler = $Handler/NPCEventHandler
@onready var npc_aggro_handler = $Handler/NPCAggroHandler
@onready var npc_loot_handler = $Handler/NPCLootHandler
@onready var npc_pathfinding_handler = $Handler/NPCPathfindingHandler
@onready var npc_memory_handler = $Handler/NPCMemoryHandler
@onready var npc_animation_handler = $Handler/NPCAnimationHandler

# Global Managers
var instance_manager
var navigation_mesh_manager
var chunk_manager
var trigger_manager

# Dictionary to store spawned NPCs by instance
var spawned_npcs = {}

var is_initialized = false

func _ready():
	initialize()

# Initialization function to set up all managers and handlers
func initialize():
	if is_initialized:
		return
	is_initialized = true

	# Initialize global managers
	instance_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "InstanceManager")
	chunk_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "ChunkManager")
	navigation_mesh_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "NavigationMeshManager")
	trigger_manager = GlobalManager.NodeManager.get_cached_node("GameWorldModule", "TriggerManager")

	# Initialize all NPC handlers
	npc_spawning_handler.initialize(self)  # Pass the manager to the handler
	npc_state_handler.initialize(self)
	npc_movement_handler.initialize(self)
	npc_health_handler.initialize(self)
	npc_event_handler.initialize(self)
	npc_aggro_handler.initialize(self)
	npc_loot_handler.initialize(self)
	npc_pathfinding_handler.initialize(self)
	npc_memory_handler.initialize(self)
	npc_animation_handler.initialize(self)

	print("NPCManager initialized successfully.")

# Method to spawn an NPC using the spawning handler
func spawn_npc(npc_type: String, instance_key: String, spawn_position: Vector2):
	return npc_spawning_handler.spawn_npc(npc_type, instance_key, spawn_position)
