# ChunkCalucationHandler
extends Node


var chunk_manager  # Reference to the ChunkManager

# Initialize with ChunkManager reference
func initialize(manager: Node):
	chunk_manager = manager


#func calculate_chunk(position: Vector2) -> Vector2:
#	return Vector2(floor(position.x / chunk_size), floor(position.y / chunk_size))

# Get a list of chunks around the player to load based on `load_distance`
#func get_chunks_around_player(chunk: Vector2) -> Array:
#	var chunks = []
#	for x_offset in range(-load_distance, load_distance + 1):
#		for y_offset in range(-load_distance, load_distance + 1):
#			chunks.append(Vector2(chunk.x + x_offset, chunk.y + y_offset))
#	return chunks
	
