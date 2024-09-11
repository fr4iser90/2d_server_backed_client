extends Node  # Oder WindowDialog für ein eigenes Fenster

# Node, das alle Spieler darstellt (z.B. in einem Popup-Fenster oder als Ansicht in der Szene)
var monitored_scene: Node = null

# Funktion zum Starten des Überwachungsfensters
func show_scene_window(scene_instance: Node):
	# Hier stellen wir sicher, dass das Fenster zur Überwachung geöffnet ist und die Szene geladen wird
	monitored_scene = scene_instance
	if monitored_scene:
		# Fügen Sie die Szene zur visuellen Überwachung hinzu (z.B. als Popup oder UI-Element)
		# Hier könnte z.B. eine zusätzliche Kamera oder UI erstellt werden
		get_tree().root.add_child(monitored_scene)
		print("Scene successfully loaded for monitoring.")
	else:
		print("Error: Could not display monitoring scene.")

# Funktion zum Entfernen des Fensters oder der Überwachung
func close_scene_window():
	if monitored_scene:
		monitored_scene.queue_free()  # Entferne die Szene
		monitored_scene = null
		print("Monitoring scene closed.")
	else:
		print("No scene to close.")
