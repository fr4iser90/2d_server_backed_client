# ChunkManager.gd
extends Node

@onready var chunk_lifecycle_handler = $Handler/ChunkLifecycleHandler
@onready var chunk_scene_manager = $Handler/ChunkSceneManager
@onready var chunk_creation_handler = $Handler/ChunkCreationHandler
@onready var chunk_cache_handler = $Handler/ChunkCacheHandler
@onready var chunk_assignment_handler = $Handler/ChunkAssignmentHandler
@onready var chunk_destruction_handler = $Handler/ChunkDestructionHandler
@onready var chunk_boundary_handler = $Handler/ChunkBoundaryHandler
@onready var chunk_event_handler = $Handler/ChunkEventHandler
@onready var chunk_loader_handler = $Handler/ChunkLoaderHandler

# Centralized scalable variables
var chunk_size = 128  # Size of a chunk in units
var load_distance = 2  # How many chunks around the player should be loaded
var max_loaded_chunks = 100  # Max number of chunks that can be loaded at once

var player_movement_manager

# Initialize the ChunkManager
func initialize():
	print("Initializing ChunkManager with chunk size: ", chunk_size)
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_manager", "player_movement_manager")
	
	# Initialize the handlers with the scalable variables
	chunk_creation_handler.initialize(self)  # Passing ChunkManager as reference
	chunk_boundary_handler.initialize(self)
	chunk_loader_handler.initialize(self)

# Handle player movement and load/unload chunks accordingly
func handle_player_movement(peer_id: int, new_position: Vector2):
	var previous_chunk = get_chunk_key(player_movement_manager.get_player_position(peer_id))
	var new_chunk = get_chunk_key(new_position)
	if previous_chunk != new_chunk:
		unload_chunk_for_player(peer_id, player_movement_manager.get_player_position(peer_id))
		load_chunk_for_player(peer_id, new_position)
	player_movement_manager.update_player_position(peer_id, new_position)

# Calculate the chunk key based on player position
func get_chunk_key(position: Vector2) -> String:
	var chunk_x = int(floor(position.x / chunk_size))
	var chunk_y = int(floor(position.y / chunk_size))
	return str(chunk_x) + ":" + str(chunk_y)

# Load a chunk based on player position
func load_chunk_for_player(peer_id: int, position: Vector2):
	var chunk_key = get_chunk_key(position)
	print("Loading chunk for player ", peer_id, " at position: ", position, " -> Chunk: ", chunk_key)
	chunk_creation_handler.load_chunk(chunk_key)

# Unload a chunk when player leaves
func unload_chunk_for_player(peer_id: int, position: Vector2):
	var chunk_key = get_chunk_key(position)
	print("Unloading chunk for player ", peer_id, " at position: ", position, " -> Chunk: ", chunk_key)
	chunk_creation_handler.unload_chunk(chunk_key)
