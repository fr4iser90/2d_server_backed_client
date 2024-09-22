extends Node

var users_data_dir = "res://data/users/"


func handle_user_data(peer_id: int, user_data: Dictionary):
	# Handle user-specific data here, e.g., login or session management
	print("User data received from peer ", peer_id, ": ", user_data)


func register_user(username: String, password: String) -> bool:
	var user_file = File.new()
	var file_path = users_data_dir + username + ".json"
	if user_file.file_exists(file_path):
		return false  # User already exists
	
	var hashed_password = hash_password(password)
	var user_data = {
		"username": username,
		"password": hashed_password,
		"characters": []
	}
	user_file.open(file_path, File.WRITE)
	user_file.store_string(to_json(user_data))
	user_file.close()
	return true

func hash_password(password: String) -> String:
	return hash_md5(password)  # Simple example, replace with stronger hashing
