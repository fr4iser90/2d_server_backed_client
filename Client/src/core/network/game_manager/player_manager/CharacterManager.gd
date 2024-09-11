extends Node

# Signal emitted when character data changes
signal character_data_changed

# Reference to the CharacterInformationManager
var character_information_manager = null

func _ready():
	# Get reference to the CharacterInformationManager
	character_information_manager = GlobalManager.GlobalNodeManager.get_cached_node("player_manager", "character_information_manager")

	# Connect the signal to listen for character data changes
	character_information_manager.connect("character_data_changed", Callable(self, "_on_character_data_changed"))

# Function that gets called when character data changes
func _on_character_data_changed(user_id: String, character_data: Dictionary):
	print("Character data updated for user: ", user_id, " -> ", character_data)
	
	# Process logic for the selected character
	var selected_character_id = character_data.get("_id", "")
	handle_character_selected(user_id, selected_character_id)

# Handle the logic for character selection
func handle_character_selected(user_id: String, character_id: String):
	print("Handling character selected for user: ", user_id, " -> Character ID: ", character_id)
	
	# Example: You can add logic to load character stats, initiate character actions, etc.
	on_character_selected(user_id, character_id)

# Logic executed after character selection
func on_character_selected(user_id: String, character_id: String):
	print("Character selected for user: ", user_id, " -> Character ID: ", character_id)

	# Add any specific logic you want to trigger after character selection
