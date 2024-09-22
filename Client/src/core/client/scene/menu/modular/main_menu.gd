extends Control

@onready var play_button = $MainMenuContainer/PlayButton
@onready var options_button = $MainMenuContainer/OptionsButton
@onready var quit_button = $MainMenuContainer/QuitButton
var menu_tree

	
func _ready():
	menu_tree = get_node("/root/Menu")
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
	#GlobalManager.SceneManager.switch_scene("connection_menu")
	_free_current_scene()
	GlobalManager.SceneManager.put_scene_at_node("connection_menu", "Menu")
	
func _free_current_scene():
	if menu_tree and menu_tree.get_child_count() > 0:
		var current_scene = menu_tree.get_child(0)  # Nimmt an, dass nur eine Szene in der "Menu" Node ist
		if current_scene:
			print("Freed scene: ", current_scene)
			current_scene.queue_free()  # Szene entfernen
			
func _on_options_button_pressed():
	GlobalManager.SceneManager.switch_scene("options_menu")

func _on_quit_button_pressed():
	get_tree().quit()  # Beendet das Spiel
