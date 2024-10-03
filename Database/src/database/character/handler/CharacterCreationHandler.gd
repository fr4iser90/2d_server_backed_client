extends Node

const CharacterModel = preload("res://data/character/CharacterModel.gd")

# Erstelle eine eindeutige ID für den Charakter
func create_unique_character_id() -> String:
	var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var random_component = ""
	for i in range(6):
		random_component += charset[int(randf() * charset.length())]
	
	# Kombiniere Unix-Zeit mit dem zufälligen String
	var unique_id = str(Time.get_unix_time_from_system()) + "_" + random_component
	return unique_id

# Standard-Charakterklassen
var default_character_classes = ["Mage", "Knight", "Archer"]

# Charakter für einen Benutzer erstellen
# This function will serialize the CharacterModel into a Dictionary
func serialize_character(character: CharacterModel) -> Dictionary:
	return {
		"name": character.name,
		"character_class": character.character_class,
		"subclass": character.subclass,
		"race": character.race,
		"gender": character.gender,
		"current_position": character.current_position,
		"current_area": character.current_area,
		"level": character.level,
		"experience": character.experience,
		"attributes": character.attributes,
		"passive_tree": character.passive_tree,
		"skills": character.skills,
		"active_skills": character.active_skills,
		"equipment": character.equipment,
		"inventory": character.inventory,
		"currencies": character.currencies,
		"professions": character.professions,
		"companions": character.companions,
		"achievements": character.achievements,
		"titles": character.titles,
		"collections": character.collections,
		"guild": character.guild,
		"guild_rank": character.guild_rank,
		"active_quests": character.active_quests,
		"completed_quests": character.completed_quests
	}

# Update the function to create characters for the user
func create_characters_for_user(user_id: String) -> Array:
	var character_list = []

	# Create a character for each class
	for char_class in default_character_classes:
		var character_id = create_unique_character_id()

		# Create a new CharacterModel instance
		var character = CharacterModel.new()
		character.name = char_class
		character.character_class = char_class
		character.level = 1
		character.experience = 0
		character.current_position = Vector2(0, 0)
		character.current_area = "spawn_room"
		character.attributes = {
			"strength": 1,
			"dexterity": 1,
			"intelligence": 1,
			"vitality": 1,
			"agility": 1,
			"luck": 1,
			"charisma": 1,
			"wisdom": 1,
			"stamina": 100,
			"mana": 100
		}

		# Serialize the character to a dictionary
		var character_data = serialize_character(character)

		# Save the serialized data to a file
		var character_file_path = "user://data/users/" + user_id + "/characters/" + character_id + ".json"
		var file = FileAccess.open(character_file_path, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(character_data))
			file.close()
			print("Character created and saved: ", character_id)

		# Add the character data to the list (serialize for JSON)
		character_list.append({
			"id": character_id,
			"data": character_data  # Add serialized data instead of resource reference
		})

	return character_list
