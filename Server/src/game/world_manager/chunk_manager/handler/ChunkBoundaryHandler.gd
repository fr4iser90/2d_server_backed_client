# ChunkBoundaryHandler.gd
extends Node

var chunk_manager  # Reference to the ChunkManager

# Initialize with ChunkManager reference
func initialize(manager: Node):
	chunk_manager = manager

# Handle player movement and check for chunk boundary crossing
func check_chunk_boundaries(peer_id: int, current_position: Vector2, previous_position: Vector2):
	var previous_chunk = get_chunk_key(previous_position)
	var new_chunk = get_chunk_key(current_position)

	if previous_chunk != new_chunk:
		for x in range(-chunk_manager.load_distance, chunk_manager.load_distance + 1):
			for y in range(-chunk_manager.load_distance, chunk_manager.load_distance + 1):
				var adjacent_chunk = get_chunk_key(Vector2(
					current_position.x + x * chunk_manager.chunk_size,
					current_position.y + y * chunk_manager.chunk_size
				))
				# Load or unload chunks accordingly
				emit_signal("chunk_boundary_crossed", peer_id, adjacent_chunk)

# Calculate the chunk key based on position
func get_chunk_key(position: Vector2) -> String:
	var chunk_x = int(floor(position.x / chunk_manager.chunk_size))
	var chunk_y = int(floor(position.y / chunk_manager.chunk_size))
	return str(chunk_x) + ":" + str(chunk_y)
