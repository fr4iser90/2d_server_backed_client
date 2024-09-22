# res://src/core/network/handler/backend_rest/core_connection_handler.gd (Client)
extends Node

# Signals to notify the client about connection status
signal connection_established()
signal connection_failed(reason: String)

var enet_client_manager = null
var channel_manager = null
var packet_manager = null
var handler_name = "core_connection_handler"
var is_initialized = false

# Initialize the connection handler
func initialize():
	if is_initialized:
		print("CoreConnectionHandler already initialized. Skipping.")
		return

	enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	channel_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "channel_manager")
	packet_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "packet_manager")
	is_initialized = true

# This function sends a connection request to the server
func request_connection():
	var enet_peer = enet_client_manager.get_enet_peer()
	if not enet_peer:
		print("ENetPeer is not initialized. Retrying in 0.1 seconds.")
		await get_tree().create_timer(0.1).timeout
		request_connection()
		return

	# Prepare the connection request packet (no session tokens here)
	var request_data = {
		"action": "connect"
	}

	# Send the connection request packet using the handler name
	var err = enet_client_manager.send_packet(handler_name, request_data)
	if err != OK:
		print("Failed to send connection request packet:", err)
	else:
		print("Connection request packet sent successfully")

# Handle packets received from the server for connection status
func handle_packet(data: Dictionary):
	if data.has("status"):
		var status = data["status"]
		if status == "connected":
			print("Connection to the server established.")
			emit_signal("connection_established")
		elif status == "disconnected":
			print("Disconnected from server.")
			emit_signal("connection_failed", "Disconnected")
		else:
			print("Unknown connection status received: ", status)
	else:
		#print("Invalid connection packet received from peer: ", peer_id)
		emit_signal("connection_failed", "Invalid packet")
