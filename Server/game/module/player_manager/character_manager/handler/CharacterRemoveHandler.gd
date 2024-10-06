# CharacterRemoveHandler.gd

extends Node

signal character_removed

func remove_character(peer_id: int, characters_data: Dictionary, exposed_data: Dictionary, sensitive_data: Dictionary):
	if characters_data.has(peer_id):
		characters_data.erase(peer_id)
		exposed_data.erase(peer_id)
		sensitive_data.erase(peer_id)
		emit_signal("character_removed", peer_id)
