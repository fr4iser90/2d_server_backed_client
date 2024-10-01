# CharacterModel.gd
extends Resource  # You can also use `extends Node` if necessary for your project

class_name CharacterModel

# Define character attributes
var name: String = ""
var character_class: String = ""
var current_area: String = "spawn_room"
var checkpoint_id: String = ""
var level: int = 1
var experience: int = 0


# Character stats
var stats = {
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

# Equipment and inventory
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
	"pet": null
}

var inventory: Array = []

# Save character data to JSON
func save_character_data(filepath: String):
	var character_data = {
		"name": name,
		"character_class": character_class,
		"current_area": current_area,
		"checkpoint_id": checkpoint_id,
		"level": level,
		"experience": experience,

		"stats": stats,
		"equipment": equipment,
		"inventory": inventory
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

# Load character data from JSON
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
			current_area = character_data["current_area"]
			checkpoint_id = character_data["checkpoint_id"]
			level = character_data["level"]
			experience = character_data["experience"]
			stats = character_data["stats"]
			equipment = character_data["equipment"]
			inventory = character_data["inventory"]
			print("Character data loaded successfully")
		else:
			print("Error parsing character data:", err)
		file.close()
	else:
		print("Error opening character file for reading")
