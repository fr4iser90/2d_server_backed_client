# res://src/core/network/handler/backend_handlers/backend_character_select_handler.gd
extends Node

# Signal for successful character selection
signal character_selected_success(character_data: Dictionary)
signal character_selection_failed(reason: String)

var network_manager = null
var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var handler_name = "backend_character_select_handler"
var is_initialized = false


func initialize():
	if is_initialized:
		print("handle_backend_login already initialized. Skipping.")
		return
	network_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "network_manager")
	enet_client_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.GlobalNodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true


func handle_packet(data: Dictionary, peer_id: int):
	if data.has("characters"):
		# Character selection successful
		print("Character selected: ", data["characters"])
		emit_signal("character_selected_success", data["characters"])
	else:
		# Invalid data or selection failed
		print("Character selection failed, invalid data received.")
		emit_signal("character_selection_failed", "Invalid data received")

# This function sends a request to the server to select a character
func select_character(request_data: Dictionary):
	# Ensure initialization before proceeding
	initialize()
		
	# Get ENetPeer from the client manager
	var enet_peer = enet_client_manager.get_enet_peer()
	if not enet_peer:
		print("ENetPeer is not initialized. Retrying in 0.1 seconds.")
		await get_tree().create_timer(0.1).timeout
		select_character(request_data)  # Retry after delay
		return
	
	var err = enet_client_manager.send_packet(handler_name, request_data)
	if err != OK:
		print("Failed to send character selection packet:", err)
	else:
		print("Character selection packet sent successfully.")
