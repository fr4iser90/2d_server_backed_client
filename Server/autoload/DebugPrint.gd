extends Node

signal log_message_emitted(message: String, level: int, caller: Object)

var global_debug_level = DebugLevel.WARNING  # Global default level
var is_debug_enabled = true  # Global Debug status

# Toggle for whether to show caller info
var show_caller_name = true  # Toggle to show script name
var show_caller_node = false  # Toggle to show node ID
var show_caller_node_path = false  # Toggle to show node path
var show_info_level = false  # Toggle to show info level
var timestamp_enabled = false  # Timestamp is disabled by default

enum DebugLevel { OFF, ERROR, WARNING, INFO, DEBUG, SYSTEM }
# Dictionary to store per-script debug levels
var script_debug_levels = {}

# BBCode colors for terminal output
var COLOR_RESET = ""
var COLOR_RED = "color=#FF0000"		# ERROR level
var COLOR_YELLOW = "color=#FFFF00"	# WARNING level
var COLOR_GREEN = "color=#00FF00" 	# INFO level
var COLOR_BLUE = "color=#0000FF"  	# DEBUG level
var COLOR_GOLD = "color=#FFD700"  	# SYSTEM level

var is_initialized = false
# Initialization
func initialize():
	if is_initialized:
		return
	is_initialized = true
	print("DebugPrint initialized.")

# Set global debug level (fallback)
func set_global_debug_level(level: int):
	global_debug_level = level

# Set per-script debug level
func set_script_debug_level(script_name: String, level: int):
	script_debug_levels[script_name] = level

# Enable or disable debugging globally
func set_debug_enabled(enabled: bool):
	is_debug_enabled = enabled

# Toggle caller name and node info separately
func set_show_caller_name(enabled: bool):
	show_caller_name = enabled

func set_show_caller_node_path(enabled: bool):
	show_caller_node_path = enabled

func set_show_caller_node(enabled: bool):
	show_caller_node = enabled

# Get the effective debug level for a script (specific level > global level)
func get_effective_debug_level(script_name: String) -> int:
	if script_name in script_debug_levels:
		return script_debug_levels[script_name]
	else:
		return global_debug_level

# Main debug function with level and caller
func debug(message: String, level: int = DebugLevel.INFO, caller: Object = null, tag: String = ""):
	if not is_debug_enabled:
		return  # If debugging is disabled globally

	var script_name = "global"
	var caller_info = ""

	if caller:
		# Get the proper node name (like "ServerConsole") instead of a generic string conversion
		script_name = caller.name if caller.has_method("get_name") else str(caller)

		# Include script name and node path if the corresponding toggles are enabled
		if show_caller_name:
			caller_info += "[" + script_name + "] "
		if show_caller_node_path and caller:
			caller_info += "[NodePath: " + String(caller.get_path()) + "] "
		if show_caller_node and caller.has_method("get_instance_id"):
			caller_info += "[NodeID: #" + str(caller.get_instance_id()) + "] "

	var effective_level = get_effective_debug_level(script_name)

	# Check if the message should be logged
	if not should_log(level, effective_level):
		return  # Don't log if the level is higher than the effective level

	# Get formatted message with BBCode colors and print
	var formatted_message = get_bbcode_colored_message(level, caller_info + message, tag)
	print("DebugPrint: ", formatted_message)
	emit_signal("log_message_emitted", formatted_message, level, caller)

# Check if a message should be logged based on the current debug level and the effective level
func should_log(message_level: int, effective_level: int) -> bool:
	# SYSTEM and ERROR levels should always log, regardless of effective level
	if message_level == DebugLevel.SYSTEM or message_level == DebugLevel.ERROR:
		return true

	# Log if the message level is less than or equal to the effective level
	return message_level <= effective_level

# Helper functions for specific levels
func debug_error(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.ERROR, caller, tag)

func debug_warning(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.WARNING, caller, tag)

func debug_info(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.INFO, caller, tag)

func debug_system(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.SYSTEM, caller, tag)

func debug_debug(message: String, caller: Object = null, tag: String = ""):
	debug(message, DebugLevel.DEBUG, caller, tag)

# Helper function to return a BBCode colored message based on the debug level
func get_bbcode_colored_message(level: int, message: String, tag: String = "") -> String:
	var timestamp = ""
	if timestamp_enabled:
		timestamp = "[" + str(Time.get_unix_time_from_system()) + "] "

	var tag_info = ""
	if tag != "":
		tag_info = "[" + tag + "] "

	# Include or exclude the debug level depending on the show_info_level toggle
	var level_info = ""
	if show_info_level:
		match level:
			DebugLevel.INFO:
				level_info = "[INFO]: "
			DebugLevel.WARNING:
				level_info = "[WARNING]: "
			DebugLevel.ERROR:
				level_info = "[ERROR]: "
			DebugLevel.DEBUG:
				level_info = "[DEBUG]: "
			DebugLevel.SYSTEM:
				level_info = "[SYSTEM]: "

	# Return the message formatted with the appropriate color and level (if enabled)
	match level:
		DebugLevel.INFO:
			return "[" + COLOR_GREEN + "]" + timestamp + tag_info + level_info + message + "[/color]"
		DebugLevel.WARNING:
			return "[" + COLOR_YELLOW + "]" + timestamp + tag_info + level_info + message + "[/color]"
		DebugLevel.ERROR:
			return "[" + COLOR_RED + "]" + timestamp + tag_info + level_info + message + "[/color]"
		DebugLevel.DEBUG:
			return "[" + COLOR_BLUE + "]" + timestamp + tag_info + level_info + message + "[/color]"
		DebugLevel.SYSTEM:
			return "[" + COLOR_GOLD + "]" + timestamp + tag_info + level_info + message + "[/color]"
		_:
			return message  # Fallback to plain message
