extends Node

func handle_character_data(peer_id: int, character_data: Dictionary):
	# Handle character-specific data here, e.g., loading character data
	print("Character data received from peer ", peer_id, ": ", character_data)
