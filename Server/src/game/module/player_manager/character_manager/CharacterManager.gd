# res://src/game/character_manager/CharacterManager.gd (Server)
extends Node

signal character_data_changed  # Signal to notify when character data is added/updated/removed
signal cleaned_character_data_changed
signal character_selected(peer_id: int, character_data: Dictionary)

var characters_data: Dictionary = {}  # Holds all character-specific data
var is_initialized = false

var instance_manager

# Initialize the manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	instance_manager.connect("instance_assigned", Callable(self, "_on_instance_assigned"))

# Add character data to the manager
func add_character_to_manager(peer_id: int, character_data: Dictionary):
	print("Adding character data to manager for peer_id: ", peer_id, " with data: ", character_data)
	# Store the cleaned character data
	characters_data[peer_id] = character_data
	emit_signal("character_selected", peer_id, character_data)
	_emit_character_data_signal(peer_id)
	_emit_cleaned_character_data_signal(peer_id)

# Update character data when it changes
func update_character_data(peer_id: int, updated_data: Dictionary):
	if characters_data.has(peer_id):
		var character_data = characters_data[peer_id]
		for key in updated_data.keys():
			character_data[key] = updated_data[key]
		characters_data[peer_id] = character_data
		_emit_character_data_signal(peer_id)

# Remove character data on logout/disconnection
func remove_character(peer_id: int):
	if characters_data.has(peer_id):
		characters_data.erase(peer_id)
		_emit_character_data_signal(peer_id)

# Handle instance assignment for a player
func _on_instance_assigned(peer_id: int, instance_key: String):
	if characters_data.has(peer_id):
		print("Instance assigned to peer_id: ", peer_id, "with instance_key: ", instance_key)
		var character_data = characters_data[peer_id]
		character_data["instance_key"] = instance_key
		characters_data[peer_id] = character_data
		_emit_character_data_signal(peer_id)

# Emit signal when character data changes
func _emit_character_data_signal(peer_id: int):
	emit_signal("character_data_changed", peer_id, characters_data.get(peer_id, {}))

# Sende Signal für bereinigte (clientseitige) Charakterdaten
func _emit_cleaned_character_data_signal(peer_id: int):
	var cleaned_data = clean_character_data(characters_data.get(peer_id, {}))
	emit_signal("cleaned_character_data_changed", peer_id, cleaned_data)
	
# Retrieve character data
func get_character_data(peer_id: int) -> Dictionary:
	return characters_data.get(peer_id, {})



# Funktion, um bereinigte Charakterdaten zu erstellen (für den Client)
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate()  # Dupliziere die Daten, um sie nicht zu verändern
	# Entferne Felder, die der Client nicht benötigt
	cleaned_data.erase("user")
	cleaned_data.erase("id")
	cleaned_data.erase("_id")
	# Weitere sensible Felder entfernen, wenn nötig
	return cleaned_data
