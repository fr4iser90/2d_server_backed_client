# LevelManager 
extends Node

@onready var level_creation_handler = $Handler/LevelCreationHandler
@onready var level_save_handler = $Handler/LevelSaveHandler
@onready var level_map_generator = $Handler/LevelMapGenerator

# Beispiel für globale Level-Daten (können angepasst werden)
var level_width = 100
var level_height = 100
var default_tile = 0

# Dies wird durch einen Knopf oder externen Trigger aufgerufen
func on_call_generate_levels_with_data_and_save():
	var generated_map = level_map_generator.generate_map(level_width, level_height, default_tile)
	level_creation_handler.create_level(generated_map)
	level_save_handler.save_level(generated_map)


