# ServerConsolePresetHandler.gd
extends Node

# Enum oder String für die Presets
enum ServerPreset {
	GodotDatabaseWebSocket,
	MongoDatabaseRestAPI,
}


# Methode, um den richtigen Initialisierungsprozess zu starten
func load_preset(selected_preset: int):
	match selected_preset:
		ServerPreset.GodotDatabaseWebSocket:
			load_godot_database_web_socket()
		ServerPreset.MongoDatabaseRestAPI:
			load_mongo_database_rest_api()
		_:
			print("Unknown preset selected")

func load_mongo_database_rest_api():
	print("Loading MongoDB REST preset...")
	var server_init = load("res://server/preset/database_mongodb_rest/server_init.gd").new()
	server_init.set_name("ServerInit")
	get_tree().root.add_child(server_init)
	server_init._ready()

func load_godot_database_web_socket():
	print("Loading Godot Database preset...")
	var server_init = load("res://server/preset/database_godot/server_init.gd").new()
	server_init.set_name("ServerInit")  
	get_tree().root.add_child(server_init)
	server_init._ready()
