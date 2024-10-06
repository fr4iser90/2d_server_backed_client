# CharacterSelectionHandler.gd

extends Node

signal character_selected

func select_character_for_peer(peer_id: int, character_name: String, characters_data: Dictionary):
	var character_data = $../CharacterUtilityHandler.get_character_data_by_name(peer_id, character_name, characters_data)
	if character_data.size() > 0:
		emit_signal("character_selected", peer_id, character_data)
	else:
		print("Character not found for peer_id: ", peer_id, " and name: ", character_name)
