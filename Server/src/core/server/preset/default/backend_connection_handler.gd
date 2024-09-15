# res://src/core/server/preset/default/backend_connection_handler.gd
extends Node

signal backend_authenticated

var network_server_backend_manager

# Setzt den Backend-Manager
func set_backend_manager(manager):
	network_server_backend_manager = manager

# Verbindet mit dem Backend
func connect_to_backend(ip: String, port: String, token: String):
	print("Connecting to backend with IP: %s, Port: %s" % [ip, port])
	
	if network_server_backend_manager:
		network_server_backend_manager.connect_to_backend(ip, port, token)
		network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_backend_authenticated"))

func _on_backend_authenticated(success: bool):
	if success:
		print("Backend successfully authenticated.")
		emit_signal("backend_authenticated", true)
	else:
		print("Backend authentication failed.")
		emit_signal("backend_authenticated", false)
