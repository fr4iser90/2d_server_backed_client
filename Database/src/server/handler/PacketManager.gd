# PacketManager
extends Node

@onready var server_manager = $"../../../../Database/Server/ServerManager"
@onready var user_manager = $"../../../../Database/User/UserManager"

func handle_server_auth(peer_id: int, packet: Dictionary):
	if packet.has("server_key"):
		var server_key = packet["server_key"]
		if typeof(server_key) == TYPE_STRING:
			server_manager.authenticate_server(peer_id, server_key)
		else:
			print("Invalid server_key type from peer ", peer_id)
	else:
		print("server_key not found in packet from peer ", peer_id)
