# res://src/database/user/UserManager.gd
extends Node

@onready var user_login_handler = $UserLoginHandler
@onready var user_logout_handler = $UserLogoutHandler
@onready var user_register_handler = $UserRegisterHandler
@onready var user_token_handler = $UserTokenHandler


var users_data_dir = "res://data/users/"

func _ready():
	print("UserManager intialized")

func handle_user_data(peer_id: int, user_data: Dictionary):
	# Handle user-specific data here, e.g., login or session management
	print("User data received from peer ", peer_id, ": ", user_data)
