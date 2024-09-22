# res://src/database/server/handler/ServerAuthHandler.gd
extends Node

const VALID_SERVER_KEY = "your_server_key_here"

func authenticate_server(peer_id: int, server_key: String):
	if server_key == VALID_SERVER_KEY:
		print("Server authenticated successfully for peer: ", peer_id)
		# Here you can send a success packet to the peer
	else:
		print("Invalid server key for peer: ", peer_id)
		# Here you can send an error packet to the peer

