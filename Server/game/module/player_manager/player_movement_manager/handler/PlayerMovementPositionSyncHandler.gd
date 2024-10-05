# PlayerMovementPositionSyncHandler.gd
extends Node

func initialize(parent: Node):
	print("Initializing PlayerMovementPositionSyncHandler")

# Synchronize player position across clients or server
func sync_position(peer_id: int, new_position: Vector2):
	print("Syncing position for peer_id: ", peer_id, " to position: ", new_position)
