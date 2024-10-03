# CharacterSelectHandler.gd
extends Node

var enet_server_manager
var database_handler
var handler_name = "character_select_handler"
var is_initialized = false

func initialize():
	if is_initialized:
		return
	enet_server_manager = GlobalManager.NodeManager.get_cached_node("network_game_module", "network_enet_server_manager")
	database_handler = GlobalManager.NodeManager.get_cached_node("network_database_handler", "database_character_select_handler")
	database_handler.connect("character_selected_success", Callable(self, "_on_character_selected_success"))
	database_handler.connect("character_selection_failed", Callable(self, "_on_character_selection_failed"))
	is_initialized = true

# Handle incoming packet from the client
func handle_packet(client_data: Dictionary, peer_id: int):
	if client_data.has("session_token") and client_data.has("character_class"):
		var server_session_token = client_data["session_token"]
		var character_class = client_data["character_class"]

		# Validate session token
		if not GlobalManager.NodeManager.get_cached_node("user_manager", "user_session_manager").validate_user_server_session_token(peer_id, server_session_token):
			_on_character_selection_failed("Invalid session token")
			return

		# Forward request to backend handler
		print("client_data: ", client_data)
		database_handler.process_character_selection(peer_id, character_class)
	else:
		_on_character_selection_failed("Missing session_token or character_class")

# Handle successful character selection and send the data to the client
func _on_character_selected_success(peer_id: int, character_data: Dictionary):
	var err = enet_server_manager.send_packet(peer_id, handler_name, character_data)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to send character selection packet to peer_id: " + str(peer_id), self)
	else:
		GlobalManager.DebugPrint.debug_info("Character selection packet sent successfully to peer_id: " + str(peer_id), self)

# Handle failed character selection and notify the client
func _on_character_selection_failed(reason: String):
	GlobalManager.DebugPrint.debug_error("Character selection failed: " + reason, self)
	# You can add additional logic to notify the client of the failure
