extends Control

@onready var mage_button = $MageButton
@onready var archer_button = $ArcherButton
@onready var knight_button = $KnightButton
@onready var logout_button = $LogoutButton

var character_data = []
var char_fetch_handler = null
var char_select_handler = null

# Initialize the character manager and connect signals
func _ready():
	_connect_signals()
	
# Connect signals for character selection and logout
func _connect_signals():
	logout_button.connect("pressed", Callable(self, "_on_logout_pressed"))
	char_fetch_handler = GlobalManager.NodeManager.get_cached_node("network_handler", "char_fetch_handler")
	char_select_handler = GlobalManager.NodeManager.get_cached_node("network_handler", "char_select_handler")

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
		if not button.is_connected("pressed", Callable(self, "_on_character_button_pressed")):
			button.connect("pressed", Callable(self, "_on_character_button_pressed").bind(str(character._id)))
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

# Handle character button press
func _on_character_button_pressed(character_id: String):
	print("Character selected with ID: ", character_id)
	_send_character_selection(character_id)

# Send character selection to the server
func _send_character_selection(character_id: String):
	print("Sending character selection to the server")
	var request_data = {
		"token": GlobalManager.GlobalConfig.get_auth_token(),
		"character_id": character_id
	}
	char_select_handler.select_character(request_data)


# Handle successful character selection
func _on_character_selected_success(characters: Dictionary, instance_key: String):
	print("Character selected successfully")
	
	var character_data = characters.get("character")
	print(character_data)
	var character_class = character_data.get("character_class")
	print(character_class)
	var character_scene_path = GlobalManager.SceneManager.scene_config.get_scene_path(character_class)
	print(character_scene_path)
	var player_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "player_manager")
	var character_manager = GlobalManager.NodeManager.get_cached_node("player_manager", "character_manager")
	GlobalManager.GlobalConfig.set_selected_character_id(character_data._id)
	character_manager.add_character_to_manager(GlobalManager.GlobalConfig.get_user_id(), character_data)
	var enet_client_manager = GlobalManager.NodeManager.get_cached_node("network_meta_manager", "enet_client_manager")
	var peer_id = enet_client_manager.get_peer_id()  # Assuming this method returns the peer ID
	# Call character manager to handle the selection logic
	player_manager.on_character_selected(GlobalManager.GlobalConfig.get_user_id(), character_data._id)
	# Hide character selection UI and proceed (no scene switch)
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

# Emit a signal to indicate the character has been selected (replace scene switching)
func _emit_character_selected_signal():
	emit_signal("character_selected")

# Handle logout button press
func _on_logout_pressed():
	print("Logging out...")
	# Add logic for handling logout if needed

