# UserLoginHandler
extends Node

var enet_server_manager 
var backend_handler 
var handler_name = "user_login_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	backend_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_user_login_handler")
	# Connect signal from backend handler to process login response
	backend_handler.connect("backend_login_processed", Callable(self, "_on_backend_login_processed"))
	is_initialized = true

# Handle incoming packet from the client
func handle_packet(client_data: Dictionary, peer_id: int):
	backend_handler.process_login(client_data, peer_id)

# Receive the processed data from the backend handler and send it to the client
func _on_backend_login_processed(peer_id: int, processed_data: Dictionary):
	var err = enet_server_manager.send_packet(peer_id, handler_name, processed_data)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send login packet to peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_info("Login packet sent successfully to peer_id: " + str(peer_id), self)
