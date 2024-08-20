extends Node

func _ready():
	# Zeige das Hauptmenü an, indem du direkt den globalen MenuManager verwendest
	MenuManager.show_menu("MainMenu")
