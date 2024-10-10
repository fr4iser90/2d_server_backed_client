extends Node

signal character_data_changed  # Signals when character data changes
signal cleaned_character_data_changed  # Signals when cleaned character data changes
signal character_selected(peer_id: int, character_data: Dictionary)  # Signals when a character is selected

@onready var character_utility_handler = $Handler/CharacterUtilityHandler
@onready var character_add_handler = $Handler/CharacterAddHandler
@onready var character_selection_handler = $Handler/CharacterSelectionHandler
@onready var character_update_handler = $Handler/CharacterUpdateHandler
@onready var character_remove_handler = $Handler/CharacterRemoveHandler

# Data dictionaries
var lightweight_characters_data: Dictionary = {}  # Holds lightweight data for all characters for each peer (name, class, etc.)
var all_characters_data: Dictionary = {}  # Holds full character data for each peer
var selected_character_data: Dictionary = {}  # Holds data of the currently selected character for each peer
var sensitive_data: Dictionary = {}  # Stores sensitive data like IDs, tokens, etc.
var exposed_data: Dictionary = {}  # Stores data that is visible to other players

var is_initialized = false
var instance_manager

# Initialize the manager once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	instance_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "instance_manager")
	instance_manager.connect("instance_assigned", Callable(self, "_on_instance_assigned"))

# Add all characters for a peer
func add_all_characters_data(peer_id: int, characters: Array):
	# Create a list to hold the reformatted character data
	var reformatted_characters = []
	for character in characters:
		var character_data = {}
		# Always access the 'data' field and merge it with the character data directly
		if character.has("data"):
			character_data = character["data"].duplicate()
			# Include the character's 'id' in the data if it exists
			character_data["id"] = character.get("id", "Unknown ID")
		else:
			character_data = character  # Handle cases where data might already be at the top level
		
		reformatted_characters.append(character_data)
	# Store the full character data for each peer directly without nesting under 'data'
	all_characters_data[peer_id] = reformatted_characters
	# Create a lightweight version of the character data
	var lightweight_data = []
	for character_data in reformatted_characters:
		lightweight_data.append(character_utility_handler.clean_lightweight_character_data(character_data))
	
	lightweight_characters_data[peer_id] = lightweight_data  # Store lightweight versions for fast access
	print("All character data and lightweight data added for peer_id:", peer_id)


# Select a character for a peer and store it in selected_character_data
func select_character_for_peer(peer_id: int, character_name: String):
	var characters = all_characters_data.get(peer_id, [])

	# Convert character_name to lowercase for a simple comparison
	var search_name = character_name.to_lower()

	for character in characters:
		# Compare the names in lowercase
		if character.get("name", "").to_lower() == search_name:
			selected_character_data[peer_id] = character  # Store the selected character data
			emit_signal("character_selected", peer_id, character)
			_emit_cleaned_character_data_signal(peer_id)
			print("Character found:", character)
			return character

	print("Character not found for peer_id:", peer_id, " and name:", search_name)
	emit_signal("character_selection_failed", "Character data not found")


# Add lightweight character data to the manager
func add_lightweight_characters_data_to_peer_id(peer_id: int, characters: Array):
	lightweight_characters_data[peer_id] = characters
	print("Lightweight characters added for peer_id:", peer_id)

# Retrieve full character data by name
func get_character_data_by_name(peer_id: int, character_name: String) -> Dictionary:
	var characters = all_characters_data.get(peer_id, [])
	for character in characters:
		if character.get("name", "").to_lower() == character_name.to_lower():
			return character  # Return full character data if the name matches
	return {}  # Return empty dictionary if no match

			
# Retrieve the selected character data for a peer
func get_selected_character_data(peer_id: int) -> Dictionary:
	print("Retrieving selected character data for peer_id:", peer_id)
	var character = selected_character_data.get(peer_id, {})
	print("Selected character data:", character)
	return character

# Store sensitive data for a peer
func store_sensitive_data(peer_id: int, sensitive_info: Dictionary):
	sensitive_data[peer_id] = sensitive_info

# Remove character data on logout or disconnection
func remove_character(peer_id: int):
	if all_characters_data.has(peer_id):
		all_characters_data.erase(peer_id)
		selected_character_data.erase(peer_id)
		lightweight_characters_data.erase(peer_id)
		sensitive_data.erase(peer_id)
		exposed_data.erase(peer_id)
		_emit_character_data_signal(peer_id)

# Emit signal when selected character data changes
func _emit_character_data_signal(peer_id: int):
	emit_signal("character_data_changed", peer_id, selected_character_data.get(peer_id, {}))

# Emit signal for cleaned (client-side) character data
func _emit_cleaned_character_data_signal(peer_id: int):
	var cleaned_data = clean_character_data(selected_character_data.get(peer_id, {}))
	emit_signal("cleaned_character_data_changed", peer_id, cleaned_data)

# Clean character data for client-side use
func clean_character_data(character_data: Dictionary) -> Dictionary:
	return character_utility_handler.clean_character_data(character_data)

# Handle instance assignment for a player
func _on_instance_assigned(peer_id: int, instance_key: String):
	if selected_character_data.has(peer_id):
		var character_data = selected_character_data[peer_id]
		character_data["instance_key"] = instance_key
		selected_character_data[peer_id] = character_data
		_emit_character_data_signal(peer_id)

# Functions to clean, expose and retrieve sensitive data
func clean_lightweight_character_data(character_data: Dictionary) -> Dictionary:
	return character_utility_handler.clean_lightweight_character_data(character_data)

func clean_characters_data(characters: Array) -> Array:
	return character_utility_handler.clean_characters_data(characters)

func expose_characters_data(characters: Array) -> Array:
	return character_utility_handler.expose_characters_data(characters)

func get_sensitive_data(character_data: Dictionary) -> Dictionary:
	return character_utility_handler.get_sensitive_data(character_data)

