extends Node

@onready var chunk_calucation_handler = $"../ChunkCalucationHandler"
@onready var chunk_creation_handler = $"../ChunkCreationHandler"
@onready var chunk_destruction_handler = $"../ChunkDestructionHandler"

var chunk_manager  # Reference to the ChunkManager
var instance_manager

# Initialize with ChunkManager reference
func initialize(manager: Node):
	chunk_manager = manager
	instance_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "instance_manager")

# Update chunk loading based on player movement
func update_chunks_for_player(peer_id: int, position: Vector2):
	var instance_key = instance_manager.get_instance_id_for_peer(peer_id)
	if instance_key == "":
		print("Error: No instance found for peer_id:", peer_id)
		return
	
	# Determine the chunks that need to be loaded around the player
	var current_chunk = chunk_calucation_handler.calculate_chunk(position)
	var chunks_to_load = chunk_calucation_handler.get_chunks_around_player(current_chunk)

	# Load the chunks
	for chunk in chunks_to_load:
		chunk_creation_handler.load_chunk(chunk)

	# Cleanup chunks that are no longer in range
	chunk_destruction_handler.clean_old_chunks(peer_id, chunks_to_load)
