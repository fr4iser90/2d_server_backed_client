extends Node

signal character_data_changed

var characters_data: Dictionary = {}  # Charakterdaten

# Charakter hinzufügen
func add_character(user_id: String, character_data: Dictionary):
	if not characters_data.has(user_id):
		characters_data[user_id] = []
	
	characters_data[user_id].append(character_data)
	emit_signal("character_data_changed", user_id, character_data)

# Charakter aktualisieren
func update_character(user_id: String, character_id: String, new_data: Dictionary):
	if characters_data.has(user_id):
		for character in characters_data[user_id]:
			if character.get("_id", "") == character_id:
				for key in new_data.keys():
					character[key] = new_data[key]
				emit_signal("character_data_changed", user_id, character)
				return
		print("Character not found.")

# Charakterdaten abrufen
func get_character_data(user_id: String, character_id: String) -> Dictionary:
	if characters_data.has(user_id):
		for character in characters_data[user_id]:
			if character.get("_id", "") == character_id:
				return character
	return {}

# ---- RPG-Spezifische Funktionen ----

# Erfahrung und Level-Management
func add_experience(user_id: String, character_id: String, experience_points: int):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var current_exp = character.get("experience", 0)
		var level = character.get("level", 1)
		character["experience"] = current_exp + experience_points
		
		# Check for level up (z.B. Level-Up bei 100 Erfahrungspunkten)
		if character["experience"] >= level * 100:
			character["level"] += 1
			character["experience"] = 0  # Reset experience after level up
			print("Character leveled up to level ", character["level"])
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

# Statistiken ändern (z.B. Stärke, Geschicklichkeit)
func update_stats(user_id: String, character_id: String, stats_update: Dictionary):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var stats = character.get("stats", {})
		for stat_name in stats_update.keys():
			stats[stat_name] = stats_update[stat_name]
		
		character["stats"] = stats
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

# Ausrüstung ändern (Waffe, Rüstung etc.)
func equip_item(user_id: String, character_id: String, slot: String, item: Dictionary):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var equipment = character.get("equipment", {})
		equipment[slot] = item
		character["equipment"] = equipment
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

# Gegenstand entfernen
func unequip_item(user_id: String, character_id: String, slot: String):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var equipment = character.get("equipment", {})
		if equipment.has(slot):
			equipment.erase(slot)
		character["equipment"] = equipment
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

# Inventar-Management
func add_item_to_inventory(user_id: String, character_id: String, item: Dictionary):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var inventory = character.get("inventory", [])
		inventory.append(item)
		character["inventory"] = inventory
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

func remove_item_from_inventory(user_id: String, character_id: String, item_id: String):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var inventory = character.get("inventory", [])
		for i in range(len(inventory)):
			if inventory[i].get("item_id", "") == item_id:
				inventory.remove_at(i)
				break
		character["inventory"] = inventory
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

# Fähigkeiten-Management (Skills)
func learn_skill(user_id: String, character_id: String, skill: Dictionary):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var skills = character.get("skills", [])
		skills.append(skill)
		character["skills"] = skills
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")

func forget_skill(user_id: String, character_id: String, skill_id: String):
	var character = get_character_data(user_id, character_id)
	if not character.empty():
		var skills = character.get("skills", [])
		for i in range(len(skills)):
			if skills[i].get("skill_id", "") == skill_id:
				skills.remove_at(i)
				break
		character["skills"] = skills
		
		emit_signal("character_data_changed", user_id, character)
	else:
		print("Character not found.")
