extends Control

@onready var singleplayer_button = $MainMenu/Singleplayer
@onready var multiplayer_button = $MainMenu/Multiplayer
@onready var options_button = $MainMenu/Options
@onready var quit_button = $MainMenu/Quit

func _ready():
	print("MainMenu ready")

	# Button-Fokus setzen
	if singleplayer_button:
		singleplayer_button.grab_focus()
	else:
		print("Warning: Singleplayer button not found!")

	# Signale verbinden
	if singleplayer_button:
		singleplayer_button.connect("pressed", Callable(self, "_on_SingleplayerButton_pressed"))
	else:
		print("Warning: Failed to connect Singleplayer button signal!")

	if multiplayer_button:
		multiplayer_button.connect("pressed", Callable(self, "_on_MultiplayerButton_pressed"))
	else:
		print("Warning: Failed to connect Multiplayer button signal!")

	if options_button:
		options_button.connect("pressed", Callable(self, "_on_OptionsButton_pressed"))
	else:
		print("Warning: Failed to connect Options button signal!")

	if quit_button:
		quit_button.connect("pressed", Callable(self, "_on_QuitButton_pressed"))
	else:
		print("Warning: Failed to connect Quit button signal!")

# Funktionen für Button-Events
func _on_SingleplayerButton_pressed():
	print("Singleplayer Button gedrückt")
	MenuManager.show_menu("SinglePlayer")

func _on_MultiplayerButton_pressed():
	print("Multiplayer Button gedrückt")
	MenuManager.show_menu("MultiplayerMenu")

func _on_OptionsButton_pressed():
	print("Options Button gedrückt")
	MenuManager.show_menu("OptionsMenu")

func _on_QuitButton_pressed():
	print("Quit Button gedrückt")
	get_tree().quit()  # Beendet das Spiel
