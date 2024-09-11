extends Control

@onready var username_input = $LoginMenuContainer/UsernameInput
@onready var password_input = $LoginMenuContainer/PasswordInput
@onready var login_button = $LoginMenuContainer/LoginButton
@onready var back_button = $LoginMenuContainer/BackButton
@onready var status_label = $LoginMenuContainer/StatusLabel

var network_manager = null
var handle_backend_login = null

func _ready():
	# Setze Standard-Username und -Passwort, falls die Eingabefelder leer sind
	if username_input.text == "":
		username_input.text = "test"
	if password_input.text == "":
		password_input.text = "test"

	# Verbindet den login_button mit der Funktion zum Login
	login_button.connect("pressed", Callable(self, "_on_login_button_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))

	# Referenz auf den NetworkManager setzen, der bereits vom ConnectionMenu erstellt wurde
	_set_network_manager_reference()

func _set_network_manager_reference():
	network_manager = GlobalManager.GlobalSceneManager.load_scene("network_manager")
	if network_manager:
		handle_backend_login = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_login_handler")
		if handle_backend_login:
			handle_backend_login.connect("login_success", Callable(self, "_on_user_logged_in_successfully"))
			handle_backend_login.connect("login_failed", Callable(self, "_on_login_failed"))
			print("HandleBackendLogin successfully referenced: ", handle_backend_login)
		else:
			print("HandleBackendLogin not found!")
	else:
		print("NetworkManager not found.")

func _on_login_button_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()

	if username == "" or password == "":
		status_label.text = "Please enter both username and password"
		return

	if handle_backend_login:
		handle_backend_login.login(username, password)
	else:
		print("HandleBackendLogin is not available.")
		
func _on_user_logged_in_successfully(username: String):
	print("User logged in successfully with username: ", username)
	status_label.text = "Login successful!"
	# Wechsle die Szene, z.B. zum Charakterauswahlmenü
	GlobalManager.GlobalSceneManager.switch_scene("character_menu")
	
func _on_login_failed(reason: String):
	print("Login failed: ", reason)
	status_label.text = "Login failed: " + reason

func _on_back_button_pressed():
	# Hier kannst du die Szene zurück zum Multiplayer-Menü wechseln lassen
	GlobalManager.GlobalSceneManager.switch_scene("multiplayer_menu")
