extends Control

@onready var start_new_game_button = $Singleplayer/StartNewGame
@onready var load_last_save_button = $Singleplayer/LoadLastSave
@onready var load_save_button = $Singleplayer/LoadSave
@onready var back_button = $Singleplayer/Back

func _ready():
	print("SingleplayerMenu ready")
	print("SingleplayerMenu ist im Baum:", self.is_inside_tree())

	# Fokus auf den ersten Button setzen
	load_last_save_button.grab_focus()
	print("Fokus auf LoadLastSave gesetzt")

	start_new_game_button.connect("pressed", Callable(self, "_on_StartNewGame_pressed"))
	load_last_save_button.connect("pressed", Callable(self, "_on_LoadLastSave_pressed"))
	load_save_button.connect("pressed", Callable(self, "_on_LoadSave_pressed"))
	back_button.connect("pressed", Callable(self, "_on_Back_pressed"))

func _on_LoadLastSave_pressed():
	print("Load Last Save gedrückt")
	# Hier der Code zum Laden des letzten Speicherstandes

func _on_LoadSave_pressed():
	print("Load Save gedrückt")
	# Hier der Code zum Laden eines spezifischen Speicherstandes

func _on_StartNewGame_pressed():
	print("Start New Game gedrückt")
	# Hier der Code zum Starten eines neuen Spiels

func _on_Back_pressed():
	print("Back gedrückt")
	get_tree().root.add_child(load("res://Shared/Menu/MainMenu/MainMenu.tscn").instantiate())
	queue_free()  # Entfernt dieses Menü
