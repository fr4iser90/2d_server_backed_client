# CharacterFetchHandler
# CharacterFetchHandler
extends Node

@onready var user_manager = $"../../../User/UserManager"

var users_data_dir = "user://data/users/"

# Fetches all characters for a user based on their user_id
func fetch_all_characters(user_id: String) -> Array:
	var user_data = user_manager.load_user_data(user_id)
	print("user_data fetch_all_characters", user_data)
	var characters = []

	if user_data.has("character_ids"):
		for character_id in user_data["character_ids"]:
			var character_data = load_character_data(user_id, character_id)
			if character_data.size() > 0:
				characters.append(character_data)
		return characters
	else:
		print("No characters found for user: ", user_id)
		return []


		
# Lädt die Charakterdaten für einen bestimmten Benutzer
func fetch_user_characters(user_data: Dictionary) -> Array:
	var character_ids = user_data["characters"]
	var characters = []
	
	for character_entry in character_ids:
		var character_id = character_entry.get("id", "")
		if character_id != "":
			var character_data = load_character_data(user_data["user_id"], character_id)
			if character_data.size() > 0:
				characters.append(character_data)
	
	return characters

# Lädt die Charakterdaten aus einer Datei basierend auf der Charakter-ID
func load_character_data(user_id: String, character_id: String) -> Dictionary:
	var file_path = users_data_dir + user_id + "/characters/" + character_id + ".json"
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())

		if error == OK:
			file.close()
			return json.get_data()
		else:
			print("Failed to parse character data for: ", character_id)
			file.close()
	return {}

