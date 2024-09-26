# res://src/game/loading_manager/LoadingManager.gd
extends Node

@onready var loading_label = $Panel/VBoxContainer/HBoxContainer5/VBoxContainer/Label
@onready var progress_bar = $Panel/VBoxContainer/HBoxContainer4/ProgressBar
@onready var simulation = $Simulation

var loading_screen: Control = null
var is_loading: bool = false

# List of loading phases and their progress percentages
var phases = [
	{"text": "Requesting server to create or assign instance...", "progress": 0.1},
	{"text": "Confirming instance and receiving initial data...", "progress": 0.15},
	{"text": "Synchronizing basic data...", "progress": 0.3},
	{"text": "Preparing scene assets...", "progress": 0.45},
	{"text": "Instantiating scene...", "progress": 0.6},
	{"text": "Requesting player and entity data...", "progress": 0.7},
	{"text": "Receiving player and entity data...", "progress": 0.8},
	{"text": "Applying player and entity positions and states...", "progress": 0.9},
	{"text": "Final synchronization and completeness check...", "progress": 0.95},
	{"text": "Loading complete!", "progress": 1.0}
]

func _ready():
	loading_screen = $LoadingScreen  # Reference to the loading screen UI element
	progress_bar = loading_screen.get_node("ProgressBar")
	loading_label = loading_screen.get_node("Label")
	loading_screen.hide()  # Hide the loading screen initially
	
# Function to display the loading screen
func start_loading():
	is_loading = true
	loading_screen.show()
	progress_bar.value = 0  # Reset progress bar
	loading_label.text = "Loading starts..."
	
# Function to hide the loading screen
func stop_loading():
	is_loading = false
	loading_screen.hide()
	
# Function to update loading progress based on the current phase
func update_loading_phase(phase_index: int):
	var phase_data = phases[phase_index]
	loading_label.text = phase_data["text"]  # Display phase description
	progress_bar.value = phase_data["progress"] * 100  # Update progress bar

# Function to handle asynchronous scene loading
func load_scene_async(scene_path: String) -> void:
	start_loading()
	# Load the scene asynchronously
	var resource_loader = ResourceLoader.load(scene_path)
	if resource_loader == null:
		print("Error: Could not load scene.")
		stop_loading()
		return
	_on_scene_loaded(resource_loader)

# This function is called after the scene is loaded
func _on_scene_loaded(scene: Resource):
	if scene:
		var packed_scene = scene as PackedScene
		if packed_scene:
			get_tree().change_scene_to_packed(packed_scene)
	stop_loading()

# Simulates loading with various phases (can be extended for multiplayer)
func simulate_loading():
	start_loading()
	for i in range(phases.size()):
		process_loading_phase(i)
		await wait_time(1)  # Simulates delay per phase

# Helper function to simulate delay
func wait_time(seconds: float) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(seconds)
	timer.start()
	await timer.timeout
	timer.queue_free()

# Function to process each loading phase (can be connected to network handlers)
func process_loading_phase(phase_index: int):
	update_loading_phase(phase_index)
	# Here, you'd call appropriate network handlers or further logic for each phase
	match phase_index:
		0:
			print("Requesting server to create or assign instance...")
		1:
			print("Confirming instance and receiving initial data...")
		2:
			print("Synchronizing basic data...")
		3:
			print("Preparing scene assets...")
		4:
			print("Instantiating scene...")
		5:
			print("Requesting player and entity data...")
		6:
			print("Receiving player and entity data...")
		7:
			print("Applying player and entity positions and states...")
		8:
			print("Final synchronization and completeness check...")
		9:
			stop_loading()
