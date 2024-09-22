extends Node

var network_manager = null

func initialize_network_manager():
	# Füge den NetworkLoader explizit zum Szenenbaum hinzu, falls er nicht bereits enthalten ist
	if get_tree() == null:
		print("Adding network_loader to the root node.")
		if get_tree().root != null:
			get_tree().root.add_child(self)
	else:
		print("network_loader is already part of the scene tree.")

	# Jetzt den NetworkManager initialisieren
	print("Initializing NetworkManager...")
	if get_tree() == null:
		print("Warning: get_tree() is null before initializing network manager.")
	else:
		print("get_tree() is valid before initializing network manager.")
	# Lade die NetworkManager-Szene
	var network_manager_scene = load("res://src/core/network/network_manager.tscn")
	if network_manager_scene == null:
		print("Failed to load NetworkManager scene.")
		return

	# Instanziiere den NetworkManager
	network_manager = network_manager_scene.instantiate()
	if network_manager == null:
		print("Failed to instantiate NetworkManager.")
		return

	# Füge den NetworkManager zum Szenenbaum hinzu
	call_deferred("_add_network_manager_to_root")

func _add_network_manager_to_root():
	print("Checking get_tree() existence:", get_tree() != null)
	print("Checking root existence:", get_tree().root != null)

	if get_tree() != null and get_tree().root != null:
		# NetworkManager zum root-Knoten hinzufügen
		get_tree().root.add_child(network_manager)
		print("Added NetworkManager to root.")
	else:
		print("Failed to add NetworkManager to root. Tree or root is null.")

	# Drucke die aktuelle Knotenstruktur nach dem Hinzufügen des NetworkManagers
	print("Tree structure after adding NetworkManager:")
	if get_tree() != null:
		print_tree_structure(get_tree().root, "")
	else:
		print("get_tree() is null after attempting to add NetworkManager.")

	if establish_network_manager():
		print("NetworkManager successfully initialized and added to the scene tree.")
	else:
		print("Failed to establish NetworkManager.")

func establish_network_manager():
	print("Establishing NetworkManager...")

	# Überprüfe, ob der NetworkManager korrekt initialisiert wurde
	if network_manager == null:
		print("Error: NetworkManager not initialized.")
		return false

	print("NetworkManager established successfully.")
	return true

# Hilfsfunktion, um die Knotenstruktur zu drucken
func print_tree_structure(node, indent):
	print(indent + node.name)
	for child in node.get_children():
		print_tree_structure(child, indent + "  ")
