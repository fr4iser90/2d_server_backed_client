# CharacterUpdateHandler.gd

extends Node

signal character_updated

func update_character_data(peer_id: int, updated_data: Dictionary, characters_data: Dictionary, exposed_data: Dictionary):
	if characters_data.has(peer_id):
		# Update character data
		for key in updated_data.keys():
			characters_data[peer_id][key] = updated_data[key]

		# Update exposed data if necessary
		for key in updated_data.keys():
			if exposed_data[peer_id].has(key):
				exposed_data[peer_id][key] = updated_data[key]
		
		emit_signal("character_updated", peer_id)
