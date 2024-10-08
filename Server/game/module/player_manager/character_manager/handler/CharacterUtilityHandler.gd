# CharacterUtilityHandler.gd
extends Node

# Lightweight character data, just basics like name and ID
func clean_lightweight_character_data(character_data: Dictionary) -> Dictionary:
	var lightweight_data = {
		"name": character_data.get("name", ""),
		"level": character_data.get("level", 1),
		"character_class": character_data.get("character_class", ""),
		"current_area": character_data.get("current_area", "")
	}
	return lightweight_data

# Function to clean character data for client-side use (removes sensitive fields)
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate(true)
	cleaned_data.erase("user_id")
	cleaned_data.erase("id")
	# Additional sensitive fields to remove
	cleaned_data.erase("_id")  # MongoDB-like unique identifier
	cleaned_data.erase("inventory")  # You might exclude large or irrelevant sections
	cleaned_data.erase("equipment")  # If necessary to exclude this
	return cleaned_data

# Function to expose character data for other players (only non-sensitive, game-related data)
func expose_character_data(character_data: Dictionary) -> Dictionary:
	return {
		"name": character_data.get("name", ""),
		"level": character_data.get("level", 1),
		"character_class": character_data.get("character_class", ""),
		"current_area": character_data.get("current_area", "")
	}

# Clean multiple characters
func clean_characters_data(characters: Array) -> Array:
	var cleaned_characters = []
	for character_data in characters:
		cleaned_characters.append(clean_character_data(character_data))
	return cleaned_characters

# Expose multiple characters
func expose_characters_data(characters: Array) -> Array:
	var exposed_characters = []
	for character_data in characters:
		exposed_characters.append(expose_character_data(character_data))
	return exposed_characters

# Get sensitive data for server use only
func get_sensitive_data(character_data: Dictionary) -> Dictionary:
	return {
		"user_id": character_data.get("user_id", ""),
		"character_id": character_data.get("character_id", "")
	}

# Retrieve character data by peer_id
func get_character_data(peer_id: int, characters_data: Dictionary) -> Dictionary:
	return characters_data.get(peer_id, {})

# Retrieve character data by character name (from the array of characters)
#func get_character_data_by_name(peer_id: int, character_name: String) -> Dictionary:
	#if characters_data.has(peer_id):
		#var peer_characters = characters_data[peer_id]
		#for character in peer_characters:
			#if character.get("name", "").to_lower() == character_name.to_lower():
				#return character  # Return full character data if the name matches
	#return {}  # Return empty dictionary if no match
	
# Lightweight data for multiple characters (e.g., for a character selection list)
func clean_lightweight_characters_data(characters: Array) -> Array:
	var lightweight_characters = []
	for character_data in characters:
		lightweight_characters.append(clean_lightweight_character_data(character_data))
	return lightweight_characters
