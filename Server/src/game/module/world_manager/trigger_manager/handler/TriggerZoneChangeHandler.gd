extends Node

func handle_trigger_entry(peer_id: int, trigger_name: String, position: Vector2):
	# Logic for handling zone change trigger entry
	print("Zone change trigger entry for peer:", peer_id, "trigger:", trigger_name, "position:", position)

func handle_trigger_exit(peer_id: int, trigger_name: String):
	# Logic for handling zone change trigger exit
	print("Zone change trigger exit for peer:", peer_id, "trigger:", trigger_name)
