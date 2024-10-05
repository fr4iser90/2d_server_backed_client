# CharacterUpdateHandler.gd
extends Node

# Update the character's position, level, experience, and area.
func update_character_data(user_id: String, character_id: String, updated_data: Dictionary):
	var character_file_path = "user://data/users/" + user_id + "/characters/" + character_id + ".json"
	
	if FileAccess.file_exists(character_file_path):
		var file = FileAccess.open(character_file_path, FileAccess.READ_WRITE)
		var json = JSON.new()
		var error = json.parse(file.get_as_text())

		if error == OK:
			var character_data = json.get_data()

			# Update the fields with the new data
			if updated_data.has("current_position"):
				character_data["current_position"] = updated_data["current_position"]
			
			if updated_data.has("level"):
				character_data["level"] = updated_data["level"]

			if updated_data.has("experience"):
				character_data["experience"] = updated_data["experience"]

			if updated_data.has("current_area"):
				character_data["current_area"] = updated_data["current_area"]

			# Save the updated character data
			file.store_string(JSON.stringify(character_data))
			file.close()
			print("Character data updated successfully.")
		else:
			print("Failed to parse character data for update.")
			file.close()
	else:
		print("Character file not found for update.")
