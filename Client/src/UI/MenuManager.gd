extends Node

# Dictionary to store preloaded menus
var menus = {}

# Reference to the currently active menu
var current_menu: Control = null

func _ready():
	if menus.size() == 0:  # Ensure menus are only initialized once
		print("MenuManager initialized")

		# Preload common menus
		menus["MainMenu"] = preload("res://src/UI/Menus/MainMenu/MainMenu.tscn").instantiate()
		menus["SinglePlayer"] = preload("res://src/UI/Menus/MainMenu/SingleplayerMenu/SingleplayerMenu.tscn").instantiate()
		menus["MultiplayerMenu"] = preload("res://src/UI/Menus/MainMenu/MultiplayerMenu/MultiplayerMenu.tscn").instantiate()
		menus["OptionsMenu"] = preload("res://src/UI/Menus/MainMenu/OptionsMenu/OptionsMenu.tscn").instantiate()
		menus["LoginMenu"] = preload("res://src/UI/Menus/MainMenu/MultiplayerMenu/LoginMenu/LoginMenu.tscn").instantiate()
		menus["CharacterMenu"] = preload("res://src/UI/Menus/MainMenu/MultiplayerMenu/LoginMenu/CharacterMenu/CharacterMenu.tscn").instantiate()

		# Add them to the scene tree but hide them
		for menu in menus.values():
			add_child(menu)
			menu.hide()

func show_menu(menu_name: String, data: Dictionary = {}):
	if current_menu != null:
		if current_menu.is_visible():
			current_menu.hide()
			print("Hiding menu: ", current_menu.name)

		# Überprüfe, ob current_menu bereits ein Kind von self ist, bevor remove_child aufgerufen wird
		if current_menu.get_parent() == self:
			remove_child(current_menu)
			print("Removing menu: ", current_menu.name)
		current_menu = null

	if menus.has(menu_name):
		current_menu = menus[menu_name]
		# Überprüfe, ob das Menü noch nicht zur Szene hinzugefügt wurde
		if current_menu.get_parent() != self:
			add_child(current_menu)

		# Wenn das Menü eine `initialize`-Methode hat, rufe sie mit den übergebenen Daten auf
		if current_menu.has_method("initialize"):
			current_menu.call("initialize", data)

		current_menu.show()
		print("Showing menu: ", menu_name)
	else:
		print("Menu not found: ", menu_name)

