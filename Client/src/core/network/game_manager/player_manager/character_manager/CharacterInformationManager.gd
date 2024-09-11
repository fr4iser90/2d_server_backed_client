extends Node

signal character_data_changed

# Ein Dictionary, das alle Charakterdaten speichert
var characters_data: Dictionary = {}

# Function zum save der Charakterdaten nach der Auswahl
func store_selected_character(user_id: String, character_data: Dictionary):
	var character_id = character_data.get("_id", "")
	print("called store : ", character_data)
	if character_id == "":
		print("Error: No valid character ID found.")
		return
	
	# Store character data for the user
	if not characters_data.has(user_id):
		characters_data[user_id] = []

	var found = false
	for i in range(len(characters_data[user_id])):
		if characters_data[user_id][i].get("_id", "") == character_id:
			characters_data[user_id][i] = character_data  # Update data
			found = true
			break
	
	# If character wasn't found, add new data
	if not found:
		characters_data[user_id].append(character_data)
	print("Current characters_data for user:", user_id, " -> ", characters_data[user_id])
	emit_signal("character_data_changed", user_id, characters_data[user_id])
	print("Character data stored for user: ", user_id, ", ID: ", character_id)


# Funktion zum Abrufen der gespeicherten Charakterdaten
func get_character_data(user_id: String, character_id: String) -> Dictionary:
	if characters_data.has(user_id):
		for character in characters_data[user_id]:
			if character.get("_id", "") == character_id:
				return character
	return {}
