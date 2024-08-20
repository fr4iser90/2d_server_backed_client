extends Control

@onready var username_input = $Login/UsernameInput
@onready var password_input = $Login/PasswordInput
@onready var login_button = $Login/Login
@onready var status_label = $Login/StatusLabel

var http_request: HTTPRequest
var auth_token: String
var menu_manager: MenuManager = null

func _ready():
	print("LoginDialog ready")

	# Finde den MenuManager in der Baum-Hierarchie
	menu_manager = get_tree().get_root().get_node("MenuManager") as MenuManager

	if not menu_manager:
		print("MenuManager not found. Please ensure it is added to the scene tree.")
	else:
		print("Using existing MenuManager instance")

	# Initialisiere HTTPRequest
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

	# Verbindet den Login-Button mit der Funktion zum Login
	login_button.connect("pressed", Callable(self, "_on_login_pressed"))

func _on_login_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()

	if username == "" or password == "":
		status_label.text = "Please enter both username and password"
		return

	login(username, password)

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	print("Server response code: ", response_code)

	if response_code == 200:
		handle_login_response(body)
	else:
		status_label.text = "Failed to connect to server, response code: " + str(response_code)

func handle_login_response(body: PackedByteArray):
	var response_text = body.get_string_from_utf8()
	print("Response Text: ", response_text)

	var json = JSON.new()
	var parse_result = json.parse(response_text)

	if parse_result == OK:
		var response = json.get_data()
		if response.has("token"):
			var token = response["token"]
			status_label.text = "Login successful, token: " + token
			auth_token = token

			# Übergebe den Token an das CharacterMenu
			MenuManager.show_menu("CharacterMenu", {"auth_token": auth_token})
		else:
			status_label.text = "Login failed: Token not found in response"
	else:
		print("Failed to parse JSON: ", response_text)
		status_label.text = "Login failed: JSON parsing error"

func login(username: String, password: String):
	var url = "http://localhost:3000/api/auth/login"
	var headers = ["Content-Type: application/json"]
	var body = {
		"username": username,
		"password": password
	}

	print("Logging in with username: ", username)

	var body_str = JSON.stringify(body)
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, body_str)

	if err != OK:
		print("Login request failed to start, error code: ", err)
		status_label.text = "Login request failed, error code: " + str(err)
	else:
		print("Login request started successfully")

func _on_back_pressed():
	# Verwende den MenuManager, um zum MultiplayerMenu zurückzukehren
	MenuManager.show_menu("MultiplayerMenu")
