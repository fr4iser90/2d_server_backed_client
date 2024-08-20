# src/Core/Network/NetworkManager.gd
extends Node

var server_url = "http://localhost:3000"
var http_request: HTTPRequest

signal login_success(token: String)
signal scene_data_received(scene_data: Dictionary)
signal error_occurred(error_message: String)

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

# Login to the server
func login(username: String, password: String):
	var url = server_url + "/api/auth/login"
	var headers = ["Content-Type: application/json"]
	var body = {"username": username, "password": password}
	var body_str = JSON.stringify(body)
	
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, body_str)
	if err != OK:
		emit_signal("error_occurred", "Failed to start login request: " + str(err))
	
func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		var response_text = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		if parse_result == OK:
			var response = json.get_data()
			if response.has("token"):
				emit_signal("login_success", response["token"])
			else:
				emit_signal("error_occurred", "Login failed: No token received")
		else:
			emit_signal("error_occurred", "JSON parsing error")
	else:
		emit_signal("error_occurred", "Server error: " + str(response_code))

# Request scene data from the server
func request_scene_data(token: String, scene_path: String):
	var url = server_url + "/api/scenes/get"
	var headers = ["Authorization: Bearer " + token]
	var body = {"scene_path": scene_path}
	var body_str = JSON.stringify(body)
	
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, body_str)
	if err != OK:
		emit_signal("error_occurred", "Failed to start scene request: " + str(err))
