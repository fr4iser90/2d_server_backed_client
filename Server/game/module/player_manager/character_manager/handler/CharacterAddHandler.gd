# CharacterAddHandler.gd

extends Node

signal character_added

func add_character_to_manager(peer_id: int, character_data: Dictionary, characters_data: Dictionary, sensitive_data: Dictionary, exposed_data: Dictionary):
	print("Adding character data for peer_id: ", peer_id, " character_data :", character_data)

	# Add the cleaned character data
	characters_data[peer_id] = $../CharacterUtilityHandler.clean_character_data(character_data)
	
	# Optionally store sensitive data (commented out in your code, but can be enabled)
	# sensitive_data[peer_id] = {
	#     "user_id": character_data["user_id"],
	#     "character_id": character_data["id"]
	# }

	# Store exposed data
	exposed_data[peer_id] = $../CharacterUtilityHandler.expose_character_data(character_data)
	
	# Emit signal
	emit_signal("character_added", peer_id, character_data)
