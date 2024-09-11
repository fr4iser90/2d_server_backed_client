# res://src/core/network/server_backend/manager/auth_server_manager.gd
extends Node

signal authentication_complete(success: bool)

var retry_count := 0
var max_retries := 3
var retry_delay := 1.0 # Sekunden

var global_config  
var is_initialized = false  

func initialize():
	if is_initialized:
		return
	is_initialized = true
	
func authenticate_server():
	if retry_count == 0:
		pass
	var delay_timer = Timer.new()
	delay_timer.wait_time = 1.0
	delay_timer.one_shot = true
	add_child(delay_timer)
	# Starte den Timer, nachdem er dem SceneTree hinzugefügt wurde
	delay_timer.connect("timeout", Callable(self, "_perform_authentication"))
	delay_timer.call_deferred("start")  # Hier call_deferred statt sofort start()

func _perform_authentication():	
	var url = GlobalManager.GlobalConfig.get_backend_url() + "/api/server/authenticate"
	print(url)
	var headers = ["Content-Type: application/json"]
	var body = {
		"server_key": GlobalManager.GlobalConfig.get_server_validation_key()
	}
	
	var body_str = JSON.stringify(body)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_authentication_completed"))
	
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, body_str)
	
	if err != OK:
		print("Server authentication request failed to start, error code: ", err)
		match err:
			HTTPRequest.RESULT_CANT_RESOLVE:
				print("Can't resolve hostname.")
			HTTPRequest.RESULT_CANT_CONNECT:
				print("Can't connect to host.")
			HTTPRequest.RESULT_CONNECTION_ERROR:
				print("Connection error occurred.")
			_:
				print("Other error occurred.")
		
		# Start retry logic
		_start_retry_authentication()

func _on_authentication_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		print("Authentication successful.")
		emit_signal("authentication_complete", true)
	else:
		print("Authentication failed with response code: ", response_code)
		_start_retry_authentication()

func _start_retry_authentication():
	if retry_count < max_retries:
		retry_count += 1
		print("Retrying authentication in ", retry_delay, " seconds... (Attempt ", retry_count, " of ", max_retries, ")")
		
		var retry_timer = Timer.new()
		retry_timer.wait_time = retry_delay
		retry_timer.one_shot = true
		add_child(retry_timer)
		
		# Starte den Timer verzögert
		retry_timer.connect("timeout", Callable(self, "_on_retry_timeout"))
		retry_timer.call_deferred("start")  # Starte ihn nach dem Hinzufügen
	else:
		print("Authentication failed after ", max_retries, " attempts.")
		emit_signal("authentication_complete", false)

func _on_retry_timeout():
	print("retry timout")
	authenticate_server()
