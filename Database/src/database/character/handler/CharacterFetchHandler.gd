# CharacterFetchHandler
# CharacterFetchHandler
extends Node

var users_data_dir = "user://data/users/"

# Lädt die Charakterdaten für einen bestimmten Benutzer
func fetch_user_characters(user_data: Dictionary) -> Array:
	var character_ids = user_data["characters"]
	var characters = []
	
	for character_entry in character_ids:
		var character_id = character_entry.get("id", "")
		if character_id != "":
			var character_data = load_character_data(user_data["username"], character_id)
			if character_data.size() > 0:
				characters.append(character_data)
	
	return characters

# Lädt die Charakterdaten aus einer Datei basierend auf der Charakter-ID
func load_character_data(username: String, character_id: String) -> Dictionary:
	var file_path = users_data_dir + username + "/characters/" + character_id + ".json"
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
