extends Area2D

# Signal to notify the main game when the player clicks on this area
signal area_clicked

# Declaring onready variables
@onready var exit_spawn_room_2 = self  # The Area2D node itself
@onready var static_body_2d = $StaticBody2D  # Reference to StaticBody2D child node
@onready var sprite = $Sprite2D
@onready var collision_shape_2d = $StaticBody2D/CollisionShape2D  # Reference to CollisionShape2D within StaticBody2D
@onready var collision_exit_spawn_room_2 = $CollisionExitSpawnRoom2  # Reference to a CollisionExit node if needed

func _ready():
	# Connect signals for mouse hover and input events
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("input_event", Callable(self, "_on_input_event"))
	collision_layer = 3  # Set to layer 3 for interactive elements
	collision_mask = 0 
	
# Function to handle mouse entering the area (hover)
func _on_mouse_entered():
	print("Mouse entered the area.")
	sprite.modulate = Color(0.5, 0.5, 0.5)  # Darken the area

# Function to handle mouse exiting the area
func _on_mouse_exited():
	print("Mouse exited the area.")
	sprite.modulate = Color(1, 1, 1)  # Reset color

# Function to handle mouse input events
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Area clicked!")
#		Wenn der Spieler in der Area von ExitSpawnRoomToSpawnRoom2Collision ist dann darf der client hier den server anfragen ob er in eine neue instanc kann ,
#		der server entfernt den user aus dieser instance dann assign in neue instance oder? und daten an clienten , wie mache ich as erstrmal richtig mit den static bods 
		emit_signal("area_clicked")  # Emit signal when the area is clicked
