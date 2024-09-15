# res://src/core/network/packet_handlers/handle_connection.gd (Server)
extends Node

@onready var backend_middleware_manager = get_node_or_null("/root/ServerMain/NetworkManager/Backend/BackendMiddlewareManager")

var handler_name = "core_connection_handler"

func initialize():
	pass
	
func handle_packet(packet_peer_id: int, packet: PackedByteArray):
	print("Handling PackedByteArray packet from peer: ", packet_peer_id)
	# Verarbeite das PackedByteArray entsprechend
	var json = JSON.new()
	var result = json.parse(packet.get_string_from_utf8())

	if result == OK:
		var data = json.result
		print("Parsed data: ", data)
		# Weitere Verarbeitung
	else:
		print("Failed to parse PackedByteArray packet from peer_id: ", packet_peer_id)

func handle_packet_dictionary(packet_peer_id: int, packet: Dictionary):
	print("Handling Dictionary packet from peer: ", packet_peer_id)
	
	# Verarbeite die Login-Daten aus dem Dictionary
	if packet.has("username") and packet.has("password"):
		var username = packet["username"]
		var password = packet["password"]
		var route_name = "login"  # Route für Login

		print("Received login data from peer_id: ", packet_peer_id)

		# Sende die Login-Anfrage an das Backend über den Middleware-Manager
		if backend_middleware_manager:
			backend_middleware_manager.handle_client_request(route_name, packet, packet_peer_id)
		else:
			print("Error: BackendMiddlewareManager not found!")
	else:
		print("Invalid login data format.")
