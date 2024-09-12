# res://src/core/game_manager/player_manager/PlayerVisiualMonitor.gd (server)
extends Node  # Oder WindowDialog für ein eigenes Fenster

# Node, das alle Spieler darstellt (z.B. in einem Popup-Fenster oder als Ansicht in der Szene)
var monitored_scene: Node = null

	

# Funktion zum Starten des Überwachungsfensters   hier die Scnene Level laden, und alles aus dem zeug vom instance manager (damit wir nur die überwachen die wir wollen) die anderen nicht
func show_scene_instnace_window(instance_key: String):
	var instance_manager = GlobalManager.GlobalNodeManager.get_cached_node("world_manager", "instance_manager")
	var instance_data = instance_manager.instances.get(instance_key, null)  # Wir holen die Instanzdaten
	print(instance_data)
	if instance_data:
		var scene_instance = instance_data["scene_instance"]
		
		# Erstelle einen Container für Szene und Spielercharaktere
		var monitored_container = Node.new()

		# Füge die Szene zum Container hinzu
		monitored_container.add_child(scene_instance)

		# Füge die Spielercharaktere zur überwachten Szene hinzu
		for player_data in instance_data["players"]:
			var player_node = player_data.get("player_node", null)
			if player_node:
				monitored_container.add_child(player_node)

		# Füge den Container zur Baumstruktur hinzu, um sie im Überwachungsfenster anzuzeigen
		get_tree().root.add_child(monitored_container)

		monitored_scene = monitored_container
		print("Scene and players successfully loaded for monitoring.")
	else:
		print("Error: Instance data not found.")

# Funktion zum Entfernen des Fensters oder der Überwachung
func close_scene_window():
	if monitored_scene:
		monitored_scene.queue_free()  # Entferne die Szene
		monitored_scene = null
		print("Monitoring scene closed.")
	else:
		print("No scene to close.")
