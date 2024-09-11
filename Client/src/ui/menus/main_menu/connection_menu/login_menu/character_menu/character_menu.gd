# res://src/ui/menus/main_menu/connection_menu/login_menu/character_menu/character_menu.gd
extends Control

@onready var knight_button = $CharacterMenuContainer/KnightButton
@onready var mage_button = $CharacterMenuContainer/MageButton
@onready var archer_button = $CharacterMenuContainer/ArcherButton
@onready var back_button = $CharacterMenuContainer/BackButton

var character_data = []
var auth_token: String
var is_fetching_characters: bool = false
var is_selecting_character: bool = false

var network_manager = null
var handle_backend_characters = null
var handle_backend_character_select = null 

func _ready():
	var auth_token = GlobalManager.GlobalConfig.get_auth_token()
	var user_id = GlobalManager.GlobalConfig.get_user_id()
	print("character_menu ready")

	if auth_token == null or auth_token == "":
		print("Auth token not set. Cannot fetch characters.")
		return

	# Reference the character handler
	_set_network_manager_reference()
	fetch_characters()
	back_button.connect("pressed", Callable(self, "_on_back_button_pressed"))

func fetch_characters():
	print("Fetching characters for user")
	is_fetching_characters = true

	# Use the backend handler to request character data
	if handle_backend_characters:
		handle_backend_characters.fetch_characters()
	else:
		print("Character fetch handler is not available")

func _set_network_manager_reference():
	network_manager = GlobalManager.GlobalSceneManager.load_scene("network_manager")
	if network_manager:
		handle_backend_characters = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_character_handler")
		handle_backend_character_select = GlobalManager.GlobalNodeManager.get_cached_node("backend_handler", "backend_character_select_handler")
		if handle_backend_characters:
			handle_backend_characters.connect("characters_fetched", Callable(self, "_on_characters_fetched"))
			handle_backend_characters.connect("characters_fetch_failed", Callable(self, "_on_characters_fetch_failed"))
		else:
			print("HandleBackendCharacters not found!")
		if handle_backend_character_select:
			handle_backend_character_select.connect("character_selected_success", Callable(self, "_on_character_selected_success"))
			handle_backend_character_select.connect("character_selection_failed", Callable(self, "_on_character_selection_failed"))
		else:
			print("HandleBackendCharacterSelect not found!")
	else:
		print("NetworkManager not found")

func _on_characters_fetched(characters: Array):
	character_data = characters
	populate_buttons()

func _on_characters_fetch_failed(reason: String):
	print("Character fetch failed: ", reason)

func populate_buttons():
	print("Populating buttons with character data")
	
	# Dictionary to map class names to buttons
	var button_map = {
		"Knight": knight_button,
		"Mage": mage_button,
		"Archer": archer_button
	}
	
	# Disable all buttons initially
	_disable_buttons()

	# Populate buttons based on character_class
	for character in character_data:
		var button = button_map.get(character.character_class, null)
		if button:
			update_button(button, character)

func update_button(button, character):
	if character:
		button.text = character.character_class + " (Level " + str(character.level) + ")"
		button.disabled = false
		button.show()
		# Bind only the character ID to the button press
		if not button.is_connected("pressed", Callable(self, "_on_character_button_pressed")):
			button.connect("pressed", Callable(self, "_on_character_button_pressed").bind(str(character._id)))  # Convert character._id to string
	else:
		button.text = "Empty"
		button.disabled = true
		button.hide()

func _disable_buttons():
	# Disable and hide all buttons before populating
	knight_button.text = "Empty"
	knight_button.disabled = true
	knight_button.hide()

	mage_button.text = "Empty"
	mage_button.disabled = true
	mage_button.hide()

	archer_button.text = "Empty"
	archer_button.disabled = true
	archer_button.hide()

func _on_character_button_pressed(character_id: String):
	print("Character selected with ID: ", character_id)
	send_character_selection(character_id)

func send_character_selection(character_id: String):
	print("Sending selected character to server with ID: ", character_id)
	GlobalManager.GlobalConfig.set_selected_character_id(character_id)  # Store the selected character ID
	
	# Prepare the request_data as a Dictionary
	var request_data = {
		"token": GlobalManager.GlobalConfig.get_auth_token(),
		"character_id": character_id
	}

	# Pass the Dictionary to the select_character function
	handle_backend_character_select.select_character(request_data)

# Handle character selection success or failure
func _on_character_selected_success(data):
	print("Character selected successfully")

	# Extract essential data from the response
	var character_data = data.character
	var character_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "character_manager")
	var character_information_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "character_information_manager")
	
	GlobalManager.GlobalConfig.set_selected_character_id(character_data._id)

	# Store the character data in CharacterInformationManager
	character_information_manager.store_selected_character(GlobalManager.GlobalConfig.get_user_id(), character_data)

	# Store scene and position details in GlobalConfig
	GlobalManager.GlobalConfig.set_selected_scene_name(character_data.scene_name)
	GlobalManager.GlobalConfig.set_spawn_point(character_data.spawn_point)
	GlobalManager.GlobalConfig.convert_dict_to_vector2(character_data.last_known_position)

	# Call CharacterManager to perform any additional logic or actions related to character selection
	character_manager.on_character_selected(GlobalManager.GlobalConfig.get_user_id(), character_data._id)

	# Switch to the client_main scene
	GlobalManager.GlobalSceneManager.switch_scene("client_main")

func _on_character_selection_failed(reason: String):
	print("Character selection failed: ", reason)

func _on_back_button_pressed():
	GlobalManager.GlobalSceneManager.switch_scene("login_menu")
