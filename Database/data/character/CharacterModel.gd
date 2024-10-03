# CharacterModel
extends Resource

class_name CharacterModel

# Basisinformationen
var name: String = ""
var character_class: String = ""  # Hauptklasse des Charakters
var subclass: String = ""  # Unterklasse des Charakters
var race: String = ""
var gender: String = ""
var main_profession: String = ""  # Hauptberuf
var secondary_profession: String = ""  # Nebenberuf
var current_position: Vector2 = Vector2(0, 0)  # Aktuelle Position in der Welt
var respawn_location: String = "default_spawn"  # Ort, an dem der Charakter wiederbelebt wird
var level: int = 1
var experience: int = 0
var faction: String = ""  # Zugehörigkeit zu einer Fraktion
var reputation: int = 0  # Ruf innerhalb der Fraktion
var alignment: String = "neutral"  # moralische Ausrichtung (z.B. "good", "evil")

# Attribute (statt Stats)
var attributes = {
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

# Passive Fähigkeiten (Passive Tree)
var passive_tree = {
	"health_regen": 0,  # Passive Fähigkeit zur Gesundheitsregeneration
	"mana_regen": 0,    # Passive Fähigkeit zur Manaregeneration
	"critical_chance": 0,   # Kritische Trefferchance
	"armor_boost": 0,   # Erhöhte Verteidigung
	"spell_power": 0    # Verstärkung für Zauber
}

# Fähigkeiten (Skills)
var skills = {
	"combat": {"swordplay": 1, "archery": 1, "magic": 1},  # Kampfskills
	"crafting": {"blacksmithing": 1, "alchemy": 1},        # Handwerk
	"gathering": {"mining": 1, "herbalism": 1}             # Sammeln
}

# Aktive Fähigkeiten (Active Skills)
var active_skills = {}

# Ausrüstung (Equipment)
var equipment = {
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
	"pet": null  # Begleiter oder Haustier
}

# Inventar (Inventory)
var inventory: Array = []  # Liste von Gegenständen

# Währungen (Currencies)
var currencies = {
	"gold": 0,        # Gold
	"gems": 0,        # Edelsteine
	"fame": 0,        # Ruhm oder Ansehen
	"tokens": 0       # Spezielle Event-Währung
}

# Berufe (Professions)
var professions = {
	"main_profession": {"blacksmithing": 0},  # Hauptberuf
	"secondary_profession": {"alchemy": 0}    # Nebenberuf
}

# Begleiter (Companions)
var companions: Array = []  # Liste von Begleitern/Pets, mit eigenen Statistiken

# Erfolge (Achievements)
var achievements: Array = []  # Liste von errungenen Erfolgen/Achievements

# Titel und Sammlungen
var titles: Array = []  # Liste der freigeschalteten Titel
var collections: Array = []  # Sammlung von Trophäen oder speziellen Gegenständen

# Gilden und Gruppen (Guilds and Relationships)
var guild: String = ""  # Name der Gilde oder Gruppe
var guild_rank: String = ""  # Rang in der Gilde

# Quests und Fortschritt
var active_quests: Array = []  # Liste von aktiven Quests
var completed_quests: Array = []  # Abgeschlossene Quests

# Speichern der Charakterdaten
func save_character_data(filepath: String):
	var character_data = {
		"name": name,
		"character_class": character_class,
		"subclass": subclass,
		"race": race,
		"gender": gender,
		"main_profession": main_profession,
		"secondary_profession": secondary_profession,
		"current_position": current_position,
		"respawn_location": respawn_location,
		"level": level,
		"experience": experience,
		"faction": faction,
		"reputation": reputation,
		"alignment": alignment,
		"attributes": attributes,
		"passive_tree": passive_tree,
		"skills": skills,
		"active_skills": active_skills,
		"equipment": equipment,
		"inventory": inventory,
		"currencies": currencies,
		"professions": professions,
		"companions": companions,
		"achievements": achievements,
		"titles": titles,
		"collections": collections,
		"guild": guild,
		"guild_rank": guild_rank,
		"active_quests": active_quests,
		"completed_quests": completed_quests
	}
	
	var json = JSON.new()
	var json_string = json.stringify(character_data)

	if json_string != null:
		var file = FileAccess.open(filepath, FileAccess.WRITE)
		if file:
			file.store_string(json_string)
			file.close()
			print("Character data saved successfully")
		else:
			print("Error opening file for writing")
	else:
		print("Error converting character data to JSON")

# Laden der Charakterdaten
func load_character_data(filepath: String):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		var json = JSON.new()
		var err = json.parse(json_data)
		if err == OK:
			var character_data = json.get_data()
			name = character_data["name"]
			character_class = character_data["character_class"]
			subclass = character_data["subclass"]
			race = character_data["race"]
			gender = character_data["gender"]
			main_profession = character_data["main_profession"]
			secondary_profession = character_data["secondary_profession"]
			current_position = character_data["current_position"]
			respawn_location = character_data["respawn_location"]
			level = character_data["level"]
			experience = character_data["experience"]
			faction = character_data["faction"]
			reputation = character_data["reputation"]
			alignment = character_data["alignment"]
			attributes = character_data["attributes"]
			passive_tree = character_data["passive_tree"]
			skills = character_data["skills"]
			active_skills = character_data["active_skills"]
			equipment = character_data["equipment"]
			inventory = character_data["inventory"]
			currencies = character_data["currencies"]
			professions = character_data["professions"]
			companions = character_data["companions"]
			achievements = character_data["achievements"]
			titles = character_data["titles"]
			collections = character_data["collections"]
			guild = character_data["guild"]
			guild_rank = character_data["guild_rank"]
			active_quests = character_data["active_quests"]
			completed_quests = character_data["completed_quests"]
			print("Character data loaded successfully")
		else:
			print("Error parsing character data:", err)
		file.close()
	else:
		print("Error opening character file for reading")
