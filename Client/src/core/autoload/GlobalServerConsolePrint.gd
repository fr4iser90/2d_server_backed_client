# res://src/core/autoloads/global_server_console_print.gd
extends Node

signal log_server_console_message(message: String)

func print_to_console(message: String):
	print("ServerConsolePrint: " + message)
	emit_signal("log_server_console_message", message)
