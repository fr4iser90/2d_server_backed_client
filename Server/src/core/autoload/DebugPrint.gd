# DebugPrint.gd
extends Node

enum DebugLevel { OFF, ERROR, WARNING, INFO, DEBUG }
var current_debug_level = DebugLevel.INFO  # Standardlevel
var is_debug_enabled = true  # Globaler Debug-Status

signal log_message_emitted(message: String, level: int, caller: Object)

var timestamp_enabled = false  # Timestamp ist standardmäßig deaktiviert
var is_initialized = false

# BBCode colors for terminal output
var COLOR_RESET = ""  # No reset needed for BBCode
var COLOR_RED = "color=#FF0000"
var COLOR_YELLOW = "color=#FFFF00"
var COLOR_GREEN = "color=#00FF00"
var COLOR_BLUE = "color=#0000FF"  # For DEBUG level

# Initialisierung
func initialize():
	if is_initialized:
		return
	is_initialized = true
	print("DebugPrint initialized.")

# Methode zum Setzen des aktuellen Debug-Levels
func set_debug_level(level: int):
	current_debug_level = level

# Methode zum Aktivieren oder Deaktivieren des Debuggings
func set_debug_enabled(enabled: bool):
	is_debug_enabled = enabled

# Debug function with level, optional caller, and optional tag
func debug(message: String, level: int = DebugLevel.INFO, caller: Object = null, tag: String = ""):
	if not is_debug_enabled or not should_log(level):
		return  # Wenn Debugging deaktiviert ist oder das Level zu niedrig ist

	var caller_info = ""
	if caller:
		caller_info = "[" + str(caller) + "] "
	
	# Get the formatted message with BBCode colors and print
	var formatted_message = get_bbcode_colored_message(level, caller_info + message, tag)
	#print("Sending debug signal: " + formatted_message)
	print(message)
	emit_signal("log_message_emitted", message, level, caller)

# Hilfsfunktionen für spezifische Level
func debug_error(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.ERROR, caller, tag)

func debug_warning(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.WARNING, caller, tag)

func debug_info(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.INFO, caller, tag)

func debug_debug(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.DEBUG, caller, tag)

# Methode, um zu entscheiden, ob die Nachricht für das aktuelle Debug-Level geloggt werden soll
func should_log(level: int) -> bool:
	# Nur wenn das Level kleiner oder gleich dem aktuellen Debug-Level ist, wird geloggt
	return level <= current_debug_level

# Helper function to return a BBCode colored message based on the debug level
func get_bbcode_colored_message(level: int, message: String, tag: String = "") -> String:
	# Optional timestamp logic
	var timestamp = ""
	if timestamp_enabled:
		timestamp = "[" + str(Time.get_unix_time_from_system()) + "] "
	# Optional tag logic
	var tag_info = ""
	if tag != "":
		tag_info = "[" + tag + "] "

	match level:
		DebugLevel.INFO:
			return "[" + COLOR_GREEN + "]" + timestamp + tag_info + "[INFO]: " + message + "[/color]"
		DebugLevel.WARNING:
			return "[" + COLOR_YELLOW + "]" + timestamp + tag_info + "[WARNING]: " + message + "[/color]"
		DebugLevel.ERROR:
			return "[" + COLOR_RED + "]" + timestamp + tag_info + "[ERROR]: " + message + "[/color]"
		DebugLevel.DEBUG:
			return "[" + COLOR_BLUE + "]" + timestamp + tag_info + "[DEBUG]: " + message + "[/color]"
		_:
			return message  # Fallback to plain message without color
