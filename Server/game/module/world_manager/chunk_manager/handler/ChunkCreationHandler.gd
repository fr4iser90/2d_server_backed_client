# ChunkCreationHandler.gd
extends Node

var loaded_chunks = {}
var chunk_manager  # Reference to the ChunkManager

# Initialize the ChunkCreationHandler and receive the ChunkManager reference
func initialize(manager: Node):
	chunk_manager = manager

# Load a chunk using the centralized chunk_size
func load_chunk(chunk_key: String):
	if loaded_chunks.has(chunk_key):
		print("Chunk already loaded: ", chunk_key)
		return
	if loaded_chunks.size() >= chunk_manager.max_loaded_chunks:
		print("Max loaded chunks reached. Unload unused chunks.")
		# Logic to unload the least recently used (LRU) chunk here

	print("Loading chunk: ", chunk_key)
	# Code to load the chunk from cache or create a new one
	loaded_chunks[chunk_key] = {}  # Store data for the loaded chunk
