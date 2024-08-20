extends Control

@onready var knight_button = $Character/Knight
@onready var mage_button = $Character/Mage
@onready var archer_button = $Character/Archer
@onready var back_button = $Character/Back

var character_data = []
var http_request: HTTPRequest
var auth_token: String

func _ready():
	print("CharacterMenu ready")

	print("Auth token in CharacterMenu: ", auth_token)

	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_request_completed"))

	if auth_token == null or auth_token == "":
		print("Auth token not set. Cannot fetch characters.")
		return

	print("Calling fetch_characters")
	fetch_characters()

	back_button.connect("pressed", Callable(self, "_on_Back_pressed"))
func initialize(data: Dictionary):
	if data.has("auth_token"):
		auth_token = data["auth_token"]
		print("Auth token received in CharacterMenu: ", auth_token)
		fetch_characters()
	else:
		print("No auth token provided to CharacterMenu")
func set_auth_token(token: String):
	auth_token = token
	print("Auth token in CharacterMenu: ", auth_token)

	# Wenn der Token gesetzt ist, rufe die Funktion zum Abrufen der Charaktere auf
	if auth_token != "":
		fetch_characters()

func fetch_characters():
	print("Fetching characters for user")
	var url = "http://localhost:3000/api/characters"
	var headers = ["Authorization: Bearer " + auth_token]

	var err = http_request.request(url, headers, HTTPClient.METHOD_GET)

	if err != OK:
		print("Character fetch request failed to start, error code: ", err)
	else:
		print("Character fetch request started successfully")

func _on_request_completed(result: int, response_code: int, headers: Array, body: PackedByteArray):
	print("Server response code: ", response_code)

	if response_code == 200:
		handle_character_response(body)
	else:
		print("Failed to fetch characters, response code: " + str(response_code))

func handle_character_response(body: PackedByteArray):
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())

	if parse_result == OK:
		var characters = json.get_data()
		print("Received characters:", characters)  # Debugging-Ausgabe

		if characters is Array:
			character_data = characters
			populate_buttons()
		else:
			print("Unexpected response format, expected an Array of characters")
	else:
		print("Failed to parse character data: ", json.get_error_message())

func populate_buttons():
	print("Populating buttons with character data")

	if character_data.size() > 0:
		update_button(knight_button, character_data[0])
	else:
		update_button(knight_button, null)

	if character_data.size() > 1:
		update_button(mage_button, character_data[1])
	else:
		update_button(mage_button, null)

	if character_data.size() > 2:
		update_button(archer_button, character_data[2])
	else:
		update_button(archer_button, null)

func update_button(button, character):
	# Directly update the button text with the character class and level
	if character:
		button.text = character.class + " (Level " + str(character.level) + ")"
		button.disabled = false  # Ensure the button is enabled
		button.show()  # Make sure the button is visible if it was hidden
		# Connect the button press event to load the character's scene
		if not button.is_connected("pressed", Callable(self, "_on_character_button_pressed")):
			button.connect("pressed", Callable(self, "_on_character_button_pressed").bind(character))
	else:
		button.text = "Empty"
		button.disabled = true  # Disable the button if no character exists
		button.hide()  # Optionally hide the button if there's no character data
		# Disconnect the button press event if no character is assigned
		if button.is_connected("pressed", Callable(self, "_on_character_button_pressed")):
			button.disconnect("pressed", self, "_on_character_button_pressed")

func _on_character_button_pressed(character):
	load_character_scene(character)

func load_character_scene(character):
	print("Loading scene from path: ", character.last_scene.path)

	# Übergang zu ClientMain.gd, nachdem der Charakter ausgewählt wurde
	var client_main = preload("res://src/Core/ClientMain.gd").new()
	client_main.initialize(character, auth_token)
	get_tree().root.add_child(client_main)

	# Menü verstecken oder entfernen
	self.queue_free()  # Entfernt das Menü, wenn nicht mehr benötigt

func _on_Back_pressed():
	MenuManager.show_menu("LoginMenu")  # Using MenuManager to return to LoginMenu
