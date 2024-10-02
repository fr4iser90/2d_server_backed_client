# LevelSaveHandler
extends Node

# Speichert die generierte Szene als .tscn-Datei
func save_level(scene_instance: Node):
	print("Speichere Level als Scene-Datei...")

	# Erzeuge einen PackedScene aus der Scene-Instanz
	var packed_scene = PackedScene.new()
	var pack_result = packed_scene.pack(scene_instance)
	
	if pack_result != OK:
		print("Fehler beim Packen der Szene:", pack_result)
		return

	# Erzeuge einen eindeutigen Dateinamen basierend auf einem Zeitstempel
	var timestamp = str(Time.get_unix_time_from_system())
	var save_path = "user://generated_level_" + timestamp + ".tscn"

	# Speichere die Szene als TSCN-Datei
	var error = ResourceSaver.save(save_path, packed_scene)
	if error == OK:
		print("Level erfolgreich gespeichert unter: ", save_path)
	else:
		print("Fehler beim Speichern des Levels:", error)
