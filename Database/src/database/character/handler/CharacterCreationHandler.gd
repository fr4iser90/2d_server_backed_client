extends Node


# Erstelle eine eindeutige ID für den Charakter
func create_unique_character_id() -> String:
	# Define the character set to include letters and digits
	var charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var random_component = ""
	
	# Generate a random string of 6 characters from the charset
	for i in range(6):
		random_component += charset[int(randf() * charset.length())]
	
	# Combine Unix time and the random component
	var unique_id = str(Time.get_unix_time_from_system()) + "_" + random_component
	
	return unique_id  # Return the generated unique ID

# Standard-Charakterklassen
var default_character_classes = ["Mage", "Knight", "Archer"]

# Charakter für einen Benutzer erstellen
func create_character_for_user(username: String) -> Array:
	var user_data = load_user_data(username)
	
	if user_data.size() == 0:
		print("User not found")
		return []
	
	var created_characters = []

	# Erstelle für jede Klasse einen Charakter
	for char_class in default_character_classes:
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

		# Erstelle eine eindeutige ID für den Charakter
		var character_id = create_unique_character_id()

		# Füge die ID in die Charakterliste des Benutzers ein
		user_data["characters"].append(character_id)

		# Speichere die aktualisierte Benutzerdatenliste
		save_user_data(username, user_data)

		# Speichere die Charakterdaten separat
		var character_file_path = "user://data/characters/" + character_id + ".json"
		var character_file = FileAccess.open(character_file_path, FileAccess.WRITE)
		if character_file:
			character_file.store_string(JSON.stringify(character_data))
			character_file.close()
			print("Character created and saved: ", character_id)
			created_characters.append(character_data)  # Füge den Charakter zur Liste hinzu
		else:
			print("Error creating character file")

	return created_characters

# Lädt die Benutzerdaten (Beispiel)
func load_user_data(username: String) -> Dictionary:
	var user_file_path = "user://data/users/" + username + ".json"
	if FileAccess.file_exists(user_file_path):
		var file = FileAccess.open(user_file_path, FileAccess.READ)
		var json = JSON.new()
		var err = json.parse(file.get_as_text())
		file.close()
		if err == OK:
			return json.get_data()
		else:
			print("Error parsing user data for user:", username)
			return {}
	else:
		return {}

# Speichere die aktualisierten Benutzerdaten (Beispiel)
func save_user_data(username: String, user_data: Dictionary):
	var user_file_path = "user://data/users/" + username + ".json"
	var file = FileAccess.open(user_file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(user_data))
		file.close()
		print("User data saved for:", username)
	else:
		print("Error saving user data for:", username)
