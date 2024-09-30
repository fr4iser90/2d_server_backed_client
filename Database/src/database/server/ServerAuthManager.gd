# res://src/database/server/ServerAuthManager.gd
extends Node

@onready var server_auth_handler = $ServerAuthHandler
@onready var server_token_handler = $ServerTokenHandler


func _ready():
	print("ServerManager intialized")
	
func authenticate_server(peer_id: int, server_key: String):
	return server_auth_handler.authenticate_server(peer_id, server_key)

func generate_token() -> String:
	# Example: A simple token generation logic
	return server_token_handler.generate_token()

func validate_token(token: String) -> bool:
	return server_token_handler.validate_token(token)
