# src/Core/AuthenticationManagement/AuthServerManager.gd
extends Node

var backend_url = "http://localhost:3000"

func authenticate_server():
	var url = backend_url + "/api/server/authenticate"
	var headers = ["Content-Type: application/json"]
	var body = {
		"server_key": "your-server-key-here"
	}
	
	var body_str = JSON.stringify(body)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_authentication_completed"))
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, body_str)
	
	if err != OK:
		print("Server authentication request failed to start, error code: ", err)

func _on_authentication_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		print("Authentication successful, Server ready to accept players.")
	else:
		print("Server authentication failed, response code: ", response_code)
