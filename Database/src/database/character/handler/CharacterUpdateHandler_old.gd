extends Node

# Update the character's position, level, experience, and area.
func update_character_data(user_id: String, character_id: String, updated_data: Dictionary):
	var character_file_path = "user://data/users/" + user_id + "/characters/" + character_id + ".json"
	
	if FileAccess.file_exists(character_file_path):
		print("Character file found at path:", character_file_path)

		var file = FileAccess.open(character_file_path, FileAccess.READ_WRITE)
		if file:
			print("Character file opened successfully.")
			
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
					print("character_data :", character_data["current_position"])
				if updated_data.has("level"):
					character_data["level"] = updated_data["level"]

				if updated_data.has("experience"):
					character_data["experience"] = updated_data["experience"]

				if updated_data.has("current_area"):
					character_data["current_area"] = updated_data["current_area"]


				# Debug print to confirm what data is being saved
				var json_string = JSON.stringify(character_data, "\t") # Pretty print for easier debugging
				print("Updated character data to be saved:", json_string)
				
				# Save the updated character data back to the file
				file.seek(0)
				file.store_string(json_string)
				file.close()
				print("Character data updated successfully.")
			else:
				print("Failed to parse character data for update.")
				print("JSON Parse Error Code:", error)
				print("JSON Error Message:", json.get_error_message())
				print("Original JSON content:", file_content) 
				file.close()
		else:
			print("Failed to open character file for read/write.")
	else:
		print("Character file not found for update.")
