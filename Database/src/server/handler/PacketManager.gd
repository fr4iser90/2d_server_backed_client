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
		

func handle_user_auth(peer_id: int, packet: Dictionary):
	# Überprüfe, ob die nötigen Felder im Paket vorhanden sind
	if packet.has("username") and packet.has("password"):
		var username = packet["username"]
		var password = packet["password"]

		# Führe die Authentifizierung durch
		user_manager.authenticate_user(peer_id, username, password)
	else:
		print("Missing username or password in packet from peer ", peer_id)

