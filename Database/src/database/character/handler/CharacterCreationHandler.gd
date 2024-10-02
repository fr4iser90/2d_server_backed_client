extends Node

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
func create_characters_for_user(user_id: String) -> Array:
	var character_list = []

	# Erstelle für jede Klasse einen Charakter
	for char_class in default_character_classes:
		var character_id = create_unique_character_id()
		var character_data = {
			"name": char_class,
			"character_class": char_class,
			"current_area": "spawn_room",
			"checkpoint_id": "",
			"level": 1,
			"experience": 0,
			"stats": {
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
			},
			"equipment": {
				"head": null,
				"chest": null,
				"legs": null,
				"weapon": null,
				"shield": null,
				"trinket_1": null,
				"trinket_2": null,
				"ring_1": null,
				"ring_2": null,
				"boots": null,
				"gloves": null,
				"belt": null,
				"pet": null
			},
			"inventory": []
		}

		# Speichere die Charakterdaten separat
		var character_file_path = "user://data/users/" + user_id + "/characters/" + character_id + ".json"
		var character_file = FileAccess.open(character_file_path, FileAccess.WRITE)
		if character_file:
			character_file.store_string(JSON.stringify(character_data))
			character_file.close()
			print("Character created and saved: ", character_id)
			character_list.append({
				"id": character_id,
				"data": character_data
			})
		else:
			print("Error creating character file: ", character_id)

	return character_list
