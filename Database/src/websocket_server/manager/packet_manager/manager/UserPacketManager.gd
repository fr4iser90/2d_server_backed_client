# UserPacketManager
extends Node

@onready var user_manager = $"../../../../../../Database/User/UserManager"

func _ready():
	print("UserPacketManager intialized")

func handle_user_packet(peer_id: int, packet: Dictionary):
	var action = packet.get("action", null)
	match action:
		"authenticate":
			user_manager.authenticate_user(peer_id, packet["username"], packet["password"])
		"logout":
			user_manager.logout_user(peer_id)
		"create_user":
			user_manager.create_user(packet["username"], packet["password"])
		"delete_user":
			user_manager.delete_user(packet["user_id"])
		"fetch_user_data":
			user_manager.load_user_data(packet["user_id"])
		"update_user_data":
			user_manager.update_user_data(packet["user_id"], packet["data"])
		"load_users_list":
			user_manager.load_users_list()
		"save_users_list":
			user_manager.save_users_list(packet["users_list"])
		"generate_token":
			var token = user_manager.generate_token()
			print("Generated token: ", token)
		"validate_token":
			var token_valid = user_manager.validate_token(packet["token"])
			print("Token valid: ", token_valid)
		_:
			print("Unknown user action: ", action)

