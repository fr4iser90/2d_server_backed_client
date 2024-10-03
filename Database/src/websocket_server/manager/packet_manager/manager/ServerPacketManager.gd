# res://src/database/server/ServerAuthManager.gd
extends Node

@onready var server_manager = $"../../../../../../Database/Server/ServerManager"


func _ready():
	print("ServerManager intialized")

func handle_server_packet(peer_id: int, packet: Dictionary):
	var action = packet.get("action", null)
	match action:
		"authenticate": 
			server_manager.authenticate_server(peer_id, packet["server_key"])
		"generate_token": 
			var token = server_manager.generate_token()
			# Send back token to the client or do further processing
			print("Generated token: ", token)
		"validate_token": 
			var token_valid = server_manager.validate_token(packet["server_session_token"])
			print("Token valid: ", token_valid)
		_:
			print("Unknown server action: ", action)
			
