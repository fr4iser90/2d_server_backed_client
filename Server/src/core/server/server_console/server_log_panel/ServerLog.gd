# ServerLog.gd
extends RichTextLabel

var debug_print_instance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the DebugPrint instance and connect the signal
	debug_print_instance = GlobalManager.DebugPrint
	if debug_print_instance:
		# Ensure the signal is connected only once
		if not debug_print_instance.is_connected("log_message_emitted",  Callable(self, "_on_log_message_emitted")):
			debug_print_instance.connect("log_message_emitted", Callable(self, "_on_log_message_emitted"))
	else:
		print("DebugPrint instance not found!")
	
	# Enable BBCode parsing to allow colors
	bbcode_enabled = true
	# Set the font size (adjust as needed)
	self.set("font_size", 3)

# Signal handler to handle log messages from DebugPrint
func _on_log_message_emitted(formatted_message: String, level: int, caller: Object):
	# Append the pre-formatted message directly
	append_text(formatted_message + "\n")
	scroll_to_line(get_line_count() - 1)

# Helper method to check if the message is a duplicate to avoid logging it twice
func is_duplicate_message(new_message: String) -> bool:
	# Get the last message in the log
	var current_text = get_text()  # Retrieves all text from the RichTextLabel
	var lines = current_text.split("\n")  # Split the text into lines

	if lines.size() > 0:
		var last_message = lines[lines.size() - 1].strip_edges()  # Get the last line
		return last_message == new_message.strip_edges()  # Compare it with the new message
	return false
