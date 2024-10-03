# ChunkCacheHandler
extends Node

var chunk_manager

# Initialize the handler
func initialize(manager: Node):
	chunk_manager = manager

# Clean up chunks that are out of range for a player
func clean_chunks_for_player(peer_id: int, loaded_chunks: Array):
	# Your logic to decide which chunks to unload
	print("Cleaning up old chunks for peer_id:", peer_id)
	# You can delegate this further to the destruction handler if needed
