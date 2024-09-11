extends Node

var player_model_paths = {
	"archer": "res://shared/data/characters/players/archer/archer.tscn",
	"knight": "res://shared/data/characters/players/knight/knight.tscn",
	"mage": "res://shared/data/characters/players/mage/mage.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_model_path(character_class: String) -> String:
	return player_model_paths.get(character_class, "")
