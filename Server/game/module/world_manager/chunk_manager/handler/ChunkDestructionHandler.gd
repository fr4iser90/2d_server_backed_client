# ChunkDestructionHandler
extends Node

var chunk_manager  # Reference to the ChunkManager

# Initialize with ChunkManager reference
func initialize(manager: Node):
	chunk_manager = manager
	
