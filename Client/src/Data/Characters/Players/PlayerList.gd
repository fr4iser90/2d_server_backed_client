extends Node

var player_model_paths = {
	"Archer": "res://src/Data/Characters/Players/Archer/Archer.tscn",
	"Knight": "res://src/Data/Characters/Players/Knight/Knight.tscn",
	"Mage": "res://src/Data/Characters/Players/Mage/Mage.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_model_path(character_class: String) -> String:
	return player_model_paths.get(character_class, "")
