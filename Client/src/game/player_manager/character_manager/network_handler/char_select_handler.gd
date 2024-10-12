# res://src/core/network/handler/backend_handlers/backend_character_select_handler.gd
extends Node

# Signal for successful character selection
signal character_selected_success(character_data: Dictionary, instance_key: String)
signal character_selection_failed(reason: String)

var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var player_movement_manager
var handler_name = "CharacterSelectService"
var is_initialized = false


func initialize():
	if is_initialized:
		return

	enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkChannelManager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkPacketManager")
	player_movement_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "PlayerMovementManager")
	is_initialized = true

# Handle packet received from the server with character and instance data
func handle_packet(data: Dictionary):
	print("handle_packet:", handle_packet)
	if data.has("characters") and data.has("instance_key"):
		# Character selection successful
		print("Character selected: ", data["characters"], " in instance: ", data["instance_key"])
		
		# Emit signal to notify the rest of the client
		emit_signal("character_selected_success", data["characters"], data["instance_key"])
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
