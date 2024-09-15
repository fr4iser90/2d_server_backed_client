# res://src/core/autoloads/global_config.gd
extends Node

# Configurable Variables
var SERVER_IP = "127.0.0.1"  
var SERVER_PORT = 9997

# Global Variables
var user_id: String = ""
var auth_token: String = ""
var selected_character_id: String = ""
var character_list: Array = []
var selected_scene_name: String = ""
var spawn_point: String = ""
var last_known_position: Vector2 = Vector2()

func _ready():
	print("Autoload: GlobalConfig intialized")
	
# Function to set the Server IP
func set_server_ip(new_server_ip: String):
	SERVER_IP = new_server_ip
	
# Function to get the Server IP
func get_server_ip() -> String:
	return SERVER_IP

# Function to set the Server Port
func set_server_port(new_server_port: int):
	SERVER_PORT = new_server_port

# Function to get the Server Port
func get_server_port() -> int:
	return SERVER_PORT

# Function to set the User ID
func set_user_id(new_user_id: String):
	user_id = new_user_id

# Function to get the User ID
func get_user_id() -> String:
	return user_id

# Function to set the Auth Token
func set_auth_token(new_auth_token: String):
	auth_token = new_auth_token

# Function to get the Auth Token
func get_auth_token() -> String:
	return auth_token

# Function to set the Character List
func set_character_list(new_character_list: Array):
	character_list = new_character_list

# Function to get the Character List
func get_character_list() -> Array:
	return character_list

# Function to set the selected Character ID
func set_selected_character_id(new_character_id: String):
	selected_character_id = new_character_id

# Function to get the selected Character ID
func get_selected_character_id() -> String:
	return selected_character_id

# Function to set the selected scene name
func set_selected_scene_name(new_scene_name: String):
	selected_scene_name = new_scene_name

# Function to get the selected scene name
func get_selected_scene_name() -> String:
	return selected_scene_name

# Function to set the spawn point
func set_spawn_point(new_spawn_point: String):
	spawn_point = new_spawn_point

# Function to get the spawn point
func get_spawn_point() -> String:
	return spawn_point

# Function to set the last known position
func set_last_known_position(new_position: Vector2):
	last_known_position = new_position

# Function to convert a dictionary with x, y to Vector2
func convert_dict_to_vector2(dict: Dictionary) -> Vector2:
	if dict.has("x") and dict.has("y"):
		return Vector2(dict["x"], dict["y"])
	else:
		return Vector2()
		
# Function to get the last known position
func get_last_known_position() -> Vector2:
	return last_known_position
