extends Control

@onready var play_button = $MainMenuContainer/PlayButton
@onready var options_button = $MainMenuContainer/OptionsButton
@onready var quit_button = $MainMenuContainer/QuitButton

	
func _ready():
	if play_button:
		play_button.grab_focus()
	else:
		print("Warning: Play button not found!")
		
	# Signale verbinden
	if play_button:
		play_button.connect("pressed", Callable(self, "_on_play_button_pressed"))
	else:
		print("Warning: Failed to connect Play button signal!")

	if options_button:
		options_button.connect("pressed", Callable(self, "_on_options_button_pressed"))
	else:
		print("Warning: Failed to connect Options button signal!")

	if quit_button:
		quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))
	else:
		print("Warning: Failed to connect Quit button signal!")

		
# Funktionen für Button-Events
func _on_play_button_pressed():
	GlobalManager.GlobalSceneManager.switch_scene("connection_menu")

func _on_options_button_pressed():
	GlobalManager.GlobalSceneManager.switch_scene("options_menu")

func _on_quit_button_pressed():
	get_tree().quit()  # Beendet das Spiel
