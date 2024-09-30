# ServerConsolePresetHandler.gd
extends Node

# Enum oder String für die Presets
enum ServerPreset {
	MONGODB_REST,
	GODOT_DATABASE
}

# Methode, um den richtigen Initialisierungsprozess zu starten
func load_preset(selected_preset: int):
	match selected_preset:
		ServerPreset.MONGODB_REST:
			load_mongodb_rest()
		ServerPreset.GODOT_DATABASE:
			load_godot_database()
		_:
			print("Unknown preset selected")

func load_mongodb_rest():
	print("Loading MongoDB REST preset...")
	var server_init = load("res://src/core/server/preset/database_mongodb_rest/server_init.gd").new()
	server_init.set_name("ServerInit")
	get_tree().root.add_child(server_init)
	server_init._ready()

func load_godot_database():
	print("Loading Godot Database preset...")
	var server_init = load("res://src/core/server/preset/database_godot/server_init.gd").new()
	server_init.set_name("ServerInit")  
	get_tree().root.add_child(server_init)
	server_init._ready()
