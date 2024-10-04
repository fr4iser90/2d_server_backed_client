# UserLoginHandler
extends Node

var enet_server_manager 
var backend_handler 
var user_session_manager
var handler_name = "user_login_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	backend_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_user_login_handler")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager")
	# Connect signal from backend handler to process login response
	backend_handler.connect("backend_login_processed", Callable(self, "_on_backend_login_processed"))
	is_initialized = true

# Handle incoming packet from the client
func handle_packet(client_data: Dictionary, peer_id: int):
	# Extract the username from the client data
	print("client_dataclient_dataclient_data ", client_data)
	var username = client_data.get("username", "")
	
	# Check if the username is already logged in
	if user_session_manager.is_user_logged_in(username):
		print("User is already logged in: " + username)
		# You can send a message back to the client here that the user is already logged in
		var err = enet_server_manager.send_packet(peer_id, handler_name, { "error": "User already logged in" })
		return
	
	# Proceed with backend login if not already logged in
	backend_handler.process_login(client_data, peer_id)

# Receive the processed data from the backend handler and send it to the client
func _on_backend_login_processed(peer_id: int, processed_data: Dictionary):
	var err = enet_server_manager.send_packet(peer_id, handler_name, processed_data)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send login packet to peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_info("Login packet sent successfully to peer_id: " + str(peer_id), self)
