extends Node

var node_state_manager = preload("res://src/core/autoloads/node_manager/NodeStateManager.gd").new()

# Funktion zum Rekursiven Durchlaufen der Knoten und Erfassung von Namen, Pfaden und Zuständen
func scan_node_tree(node: Node) -> void:
	# Gib den Namen des aktuellen Knotens und seinen Szenenbaum-Pfad aus
	var node_name = node.name
	var node_path = node.get_path()
	
	# Wenn der Knoten ein Skript hat, erhalte den Pfad der zugewiesenen Datei
	var script_path = ""
	if node.get_script() != null:
		script_path = node.get_script().resource_path
	
	# Ausgabe der Knoteninformationen
	print("Node Name: %s, Node Path: %s, Script Path: %s" % [node_name, node_path, script_path])
	
	# Zusätzliche Informationen zum Status des Knotens (falls vorhanden)
	if node_state_manager != null and node_state_manager.check_node_ready(node_name):
		print("%s is ready." % node_name)
	else:
		print("%s is not ready or no state manager assigned." % node_name)

	# Rekursiver Aufruf für alle Kindknoten
	for child in node.get_children():
		if child is Node:
			scan_node_tree(child)

