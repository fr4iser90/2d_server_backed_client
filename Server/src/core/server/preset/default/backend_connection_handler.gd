# res://src/core/server/preset/default/backend_connection_handler.gd
extends Node

signal backend_authenticated

var network_server_backend_manager


# Verbindet mit dem Backend
func connect_to_backend(ip: String, port: String, token: String):
	print("Connecasdsadasdasdting to backend with IP: %s, Port: %s" % [ip, port])
	var network_server_backend_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "network_server_client_manager")
	if network_server_backend_manager:
		print("connecting????")
		network_server_backend_manager.connect_to_backend(ip, port, token)
		network_server_backend_manager.connect("network_server_backend_authentication_success", Callable(self, "_on_backend_authenticated"))
	else:
		print("Error")

func _on_backend_authenticated(success: bool):
	if success:
		print("Backend successfully authenticated.")
		emit_signal("backend_authenticated", true)
	else:
		print("Backend authentication failed.")
		emit_signal("backend_authenticated", false)
