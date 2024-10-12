extends Control

@onready var mage_button = $MageButton
@onready var archer_button = $ArcherButton
@onready var knight_button = $KnightButton
@onready var logout_button = $LogoutButton

var character_data = []
var char_fetch_handler = null
var char_select_handler = null
var user_session_manager = null

# Initialize the character manager and connect signals
func _ready():
	_connect_signals()
	
# Connect signals for character selection and logout
func _connect_signals():
	logout_button.connect("pressed", Callable(self, "_on_logout_pressed"))
	char_fetch_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "CharFetchService")
	char_select_handler = GlobalManager.NodeManager.get_cached_node("NetworkGameModuleService", "CharSelectService")
	user_session_manager = GlobalManager.NodeManager.get_cached_node("UserSessionModule", "UserSessionManager")

	# Connect signals for character fetching and selection
	if char_fetch_handler:
		char_fetch_handler.connect("characters_fetched", Callable(self, "_on_characters_fetched"))
		char_fetch_handler.connect("characters_fetch_failed", Callable(self, "_on_characters_fetch_failed"))
	else:
		print("Character handler not available")

	if char_select_handler:
		char_select_handler.connect("character_selected_success", Callable(self, "_on_character_selected_success"))
		char_select_handler.connect("character_selection_failed", Callable(self, "_on_character_selection_failed"))
	else:
		print("Character select handler not available")
	
# Fetch character data from the server
func fetch_characters():
	print("Fetching characters...")
	char_fetch_handler.fetch_characters()

# Populate the character buttons with fetched data
func _on_characters_fetched(characters: Array):
	character_data = characters
	_populate_buttons()

# Handle failed character fetch
func _on_characters_fetch_failed(reason: String):
	print("Failed to fetch characters: ", reason)

# Populate the buttons with available characters
func _populate_buttons():
	var button_map = {
		"Knight": knight_button,
		"Mage": mage_button,
		"Archer": archer_button
	}

	_disable_buttons()  # Reset buttons

	# Enable and update buttons based on the fetched character data
	for character in character_data:
		var button = button_map.get(character.character_class, null)
		if button:
			_update_button(button, character)

# Update individual buttons with character info
func _update_button(button, character):
	if character:
		button.text = character.character_class + " (Level " + str(character.level) + ")"
		button.disabled = false
		button.show()
		# Bind the character class instead of character ID
		if not button.is_connected("pressed", Callable(self, "_on_character_button_pressed")):
			button.connect("pressed", Callable(self, "_on_character_button_pressed").bind(character.character_class))
	else:
		button.text = "Empty"
		button.disabled = true
		button.hide()

# Disable all buttons initially
func _disable_buttons():
	knight_button.text = "Empty"
	knight_button.disabled = true
	knight_button.hide()

	mage_button.text = "Empty"
	mage_button.disabled = true
	mage_button.hide()

	archer_button.text = "Empty"
	archer_button.disabled = true
	archer_button.hide()

# Handle character button press by sending the character class instead of ID
func _on_character_button_pressed(character_class: String):
	print("Character selected with class: ", character_class)
	_send_character_selection(character_class)

# Send character selection to the server
func _send_character_selection(character_class: String):
	print("Sending character selection to the server")
	
	var request_data = {
		"session_token": user_session_manager.get_session_token(),  # Use the session token
		"character_class": character_class  # Send character_class instead of character_id
	}
	char_select_handler.select_character(request_data)

# Handle successful character selection
func _on_character_selected_success(characters: Dictionary, instance_key: String):
	print("Character selected successfully: ", characters)
	var character_data = characters
	var character_class = character_data.get("character_class")
	var character_scene_path = GlobalManager.SceneManager.scene_config.get_scene_path(character_class)
	var player_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "PlayerManager")
	var character_manager = GlobalManager.NodeManager.get_cached_node("GamePlayerModule", "CharacterManager")
	var enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	var peer_id = enet_client_manager.get_peer_id()  # Assuming this method returns the peer ID

	# Call character manager to handle the selection logic
	player_manager.on_character_selected(peer_id)

	# Hide character selection UI and proceed
	_free_menu_and_children()
	var client_main = get_node("/root/ClientMain")
	if client_main:
		client_main.initialize_player_and_scene(character_data, instance_key, peer_id)
	else:
		print("ClientMain not found")
		
# Function to free the "Menu" node and its children without affecting the root
func _free_menu_and_children():
	var menu_node = get_node("/root/Menu")  # Find the Menu node specifically
	if menu_node:
		menu_node.queue_free()  # Free the Menu node and its children
	else:
		print("Menu node not found!")
		
# Handle failed character selection
func _on_character_selection_failed(reason: String):
	print("Character selection failed: ", reason)

# Handle logout button press
func _on_logout_pressed():
	print("Logging out...")
	# Add logic for handling logout if needed
