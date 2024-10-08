extends Node

# Update the character's position, level, experience, and area.
func update_character_data(user_id: String, character_id: String, updated_data: Dictionary):
	var character_file_path = "user://data/users/" + user_id + "/characters/" + character_id + ".json"

	if FileAccess.file_exists(character_file_path):
		print("Character file found at path:", character_file_path)

		var file = FileAccess.open(character_file_path, FileAccess.READ)
		if file:
			print("Character file opened successfully for reading.")
			
			var file_content = file.get_as_text()
			print("Character file content before parsing:", file_content)
			
			var json = JSON.new()
			var error = json.parse(file_content)

			if error == OK:
				var character_data = json.get_data()
				print("Character data parsed successfully:", character_data)

				# Update the fields with the new data
				if updated_data.has("current_position"):
					character_data["current_position"] = updated_data["current_position"]
				
				if updated_data.has("level"):
					character_data["level"] = updated_data["level"]

				if updated_data.has("experience"):
					character_data["experience"] = updated_data["experience"]

				if updated_data.has("current_area"):
					character_data["current_area"] = updated_data["current_area"]

				# Close the file opened for reading before writing the new data
				file.close()
				
				# Open the file in WRITE mode to overwrite with the updated data
				file = FileAccess.open(character_file_path, FileAccess.WRITE)
				if file:
					# Debug print to confirm what data is being saved
					var json_string = JSON.stringify(character_data, "\t") # Pretty print for easier debugging
					print("Updated character data to be saved:", json_string)

					file.store_string(json_string)
					file.close()
					print("Character data updated and saved successfully.")
				else:
					print("Failed to open character file for writing.")
			else:
				print("Failed to parse character data for update.")
				print("JSON Parse Error Code:", error)
				print("JSON Error Message:", json.get_error_message())
				file.close()
		else:
			print("Failed to open character file for reading.")
	else:
		print("Character file not found for update.")
