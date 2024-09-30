# DatabaseAuthServerHandler
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
	GlobalManager.DebugPrint.debug_info("auth_server_manager initialized.", self)

func authenticate_server():
	if not is_initialized:
		initialize()
	if retry_count == 0:
		GlobalManager.DebugPrint.debug_info("Starting initial server authentication...", self)
	
	var delay_timer = Timer.new()
	delay_timer.wait_time = 1.0
	delay_timer.one_shot = true
	add_child(delay_timer)
	delay_timer.connect("timeout", Callable(self, "_perform_authentication"))
	delay_timer.call_deferred("start")

func _perform_authentication():
	var url = GlobalManager.GlobalConfig.get_backend_url() + "/api/server/authenticate"
	GlobalManager.DebugPrint.debug_info("Performing authentication request to URL: " + url, self)

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
		GlobalManager.DebugPrint.debug_error("Server authentication request failed to start, error code: " + str(err), self)
		match err:
			HTTPRequest.RESULT_CANT_RESOLVE:
				GlobalManager.DebugPrint.debug_error("Can't resolve hostname.", self)
			HTTPRequest.RESULT_CANT_CONNECT:
				GlobalManager.DebugPrint.debug_error("Can't connect to host.", self)
			HTTPRequest.RESULT_CONNECTION_ERROR:
				GlobalManager.DebugPrint.debug_error("Connection error occurred.", self)
			_:
				GlobalManager.DebugPrint.debug_error("Other error occurred.", self)
		
		_start_retry_authentication()

func _on_authentication_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		GlobalManager.DebugPrint.debug_info("Authentication successful.", self)
		emit_signal("authentication_complete", true)
	else:
		GlobalManager.DebugPrint.debug_warning("Authentication failed with response code: " + str(response_code), self)
		_start_retry_authentication()

func _start_retry_authentication():
	if retry_count < max_retries:
		retry_count += 1
		GlobalManager.DebugPrint.debug_warning("Retrying authentication in " + str(retry_delay) + " seconds... (Attempt " + str(retry_count) + " of " + str(max_retries) + ")", self)
		
		var retry_timer = Timer.new()
		retry_timer.wait_time = retry_delay
		retry_timer.one_shot = true
		add_child(retry_timer)
		retry_timer.connect("timeout", Callable(self, "_on_retry_timeout"))
		retry_timer.call_deferred("start")
	else:
		GlobalManager.DebugPrint.debug_error("Authentication failed after " + str(max_retries) + " attempts.", self)
		emit_signal("authentication_complete", false)

func _on_retry_timeout():
	GlobalManager.DebugPrint.debug_info("Retrying authentication...", self)
	authenticate_server()
