# CharacterManager
extends Node

@onready var character_creation_handler = $CharacterCreationHandler
@onready var character_select_handler = $CharacterSelectHandler
@onready var character_fetch_handler = $CharacterFetchHandler
@onready var character_remove_handler = $CharacterRemoveHandler


func create_characters_for_user(user_id: String) -> Array:
	return character_creation_handler.create_characters_for_user(user_id)

func fetch_user_characters(user_data: Dictionary) -> Array:
	return character_fetch_handler.fetch_user_characters(user_data)

func load_character_data(username: String, character_id: String) -> Dictionary:
	return character_fetch_handler.load_character_data(username, character_id)

func fetch_all_characters(user_id: String) -> Array:
	return character_fetch_handler.fetch_all_characters(user_id)
