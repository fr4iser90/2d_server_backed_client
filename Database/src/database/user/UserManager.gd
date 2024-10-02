# res://src/database/user/UserManager.gd
extends Node

@onready var user_login_handler = $UserLoginHandler
@onready var user_create_handler = $UserCreateHandler
@onready var user_token_handler = $UserTokenHandler
@onready var user_fetch_handler = $UserFetchHandler
@onready var user_utility_handler = $UserUtilityHandler

@onready var web_socket_manager = $"../../../WebSocketServer/Manager/WebSocketManager"


func _ready():
	print("UserManager intialized")

# Lädt die Liste der Benutzernamen
func load_users_list() -> Array:
	return user_fetch_handler.load_users_list()

# Lädt die Liste der Benutzernamen
func fetch_all_users() -> Array:
	return user_fetch_handler.fetch_all_users()
	
# Lädt Benutzerdaten (z.B. Passwort)
func load_user_data(username: String) -> Dictionary:
	return user_fetch_handler.load_user_data(username)
	
# Speichert die Liste der Benutzernamen
func save_users_list(users_list: Array) -> void:
	return user_utility_handler.load_users_list(users_list)

	
func create_user(username: String, password: String):
	return user_create_handler.create_user(username, password)
	
func authenticate_user(peer_id: int, username: String, password: String):
	return user_login_handler.authenticate_user(peer_id, username, password)

func _send_login_error(peer_id: int, error_message: String):
	print("error")
	web_socket_manager._send_json_to_peer(peer_id, error_message)
	
func _send_login_success(peer_id: int, user_data: String):
	print("success")
	web_socket_manager._send_json_to_peer(peer_id, user_data)
