# ServerLog.gd
extends RichTextLabel

var debug_print_instance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the DebugPrint instance and connect the signal
	debug_print_instance = GlobalManager.DebugPrint
	if debug_print_instance:
		debug_print_instance.connect("log_message_emitted", Callable(self, "_on_log_message_emitted"))
	else:
		print("DebugPrint instance not found!")
	# Enable BBCode parsing to allow colors
	bbcode_enabled = true
	# Set the font size
	self.set("font_size", 3)

# Signal handler to handle log messages from DebugPrint
func _on_log_message_emitted(message: String, level: int, caller: Object, tag: String = ""):
	print("Log message received: " + message + " | Level: " + str(level))
	log_message_with_level(message, level, caller, tag)

# Method to append a log message with level, caller, and tag information
func log_message_with_level(message: String, level: int = 2, caller: Object = null, tag: String = ""):
	var caller_info = ""
	if caller:
		caller_info = "[" + str(caller) + "] "

	var formatted_message = GlobalManager.DebugPrint.get_bbcode_colored_message(level, caller_info + message, tag)
	append_text(formatted_message + "\n")
	scroll_to_line(get_line_count() - 1)
