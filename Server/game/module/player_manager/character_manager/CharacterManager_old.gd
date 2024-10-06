extends Node

signal character_data_changed  # To notify of any updates or changes
signal cleaned_character_data_changed
signal character_selected(peer_id: int, character_data: Dictionary)

var characters_data: Dictionary = {}  # Holds all character data for each peer
var sensitive_data: Dictionary = {}  # Stores sensitive data like IDs, tokens, etc.
var exposed_data: Dictionary = {}  # Stores data visible to other players
var is_initialized = false

var instance_manager

# Initialize the manager only once
func initialize():
	if is_initialized:
		return
	is_initialized = true
	instance_manager = GlobalManager.NodeManager.get_cached_node("world_manager", "instance_manager")
	instance_manager.connect("instance_assigned", Callable(self, "_on_instance_assigned"))

# Add character data to the manager (separate sensitive, client, and exposed data)
func add_character_to_manager(peer_id: int, character_data: Dictionary):
	print("Adding character data for peer_id: ", peer_id, " character_data :", character_data)

	# Separate sensitive data
	#var sensitive_info = {
		#"user_id": character_data["user_id"],
		#"character_id": character_data["id"]
	#}
	#sensitive_data[peer_id] = sensitive_info

	# Store client and exposed data
	characters_data[peer_id] = clean_character_data(character_data)  # Client data
	exposed_data[peer_id] = expose_character_data(character_data)  # Data visible to other players

	emit_signal("character_selected", peer_id, character_data)
	_emit_character_data_signal(peer_id)
	_emit_cleaned_character_data_signal(peer_id)

# Update character data when it changes (both client and exposed data)
func update_character_data(peer_id: int, updated_data: Dictionary):
	if characters_data.has(peer_id):
		# Update client-specific data
		for key in updated_data.keys():
			characters_data[peer_id][key] = updated_data[key]

		# Update exposed data
		for key in updated_data.keys():
			exposed_data[peer_id][key] = updated_data[key] if exposed_data[peer_id].has(key) else exposed_data[peer_id][key]

		_emit_character_data_signal(peer_id)

# Remove character data on logout/disconnection
func remove_character(peer_id: int):
	if characters_data.has(peer_id):
		characters_data.erase(peer_id)
		exposed_data.erase(peer_id)
		sensitive_data.erase(peer_id)
		_emit_character_data_signal(peer_id)

# Handle instance assignment for a player
func _on_instance_assigned(peer_id: int, instance_key: String):
	if characters_data.has(peer_id):
		var character_data = characters_data[peer_id]
		character_data["instance_key"] = instance_key
		characters_data[peer_id] = character_data
		_emit_character_data_signal(peer_id)

# Emit signal when character data changes
func _emit_character_data_signal(peer_id: int):
	emit_signal("character_data_changed", peer_id, characters_data.get(peer_id, {}))

# Emit signal for cleaned (client-side) character data
func _emit_cleaned_character_data_signal(peer_id: int):
	var cleaned_data = clean_character_data(characters_data.get(peer_id, {}))
	emit_signal("cleaned_character_data_changed", peer_id, cleaned_data)

# Retrieve sensitive data for server-side usage only
func get_sensitive_character_data(peer_id: int) -> Dictionary:
	return sensitive_data.get(peer_id, {})

# Function to clean character data for client-side use
func clean_character_data(character_data: Dictionary) -> Dictionary:
	var cleaned_data = character_data.duplicate()
	cleaned_data.erase("user_id")
	cleaned_data.erase("id")
	# Additional sensitive fields to remove can be added here
	return cleaned_data

# Function to expose character data for other players
func expose_character_data(character_data: Dictionary) -> Dictionary:
	var exposed_data = {
		"name": character_data["name"],
		"level": character_data["level"],
		"character_class": character_data["character_class"],
		"current_area": character_data["current_area"]  # Optional: only expose if necessary
	}
	return exposed_data

# Retrieve character data
func get_character_data(peer_id: int) -> Dictionary:
	return characters_data.get(peer_id, {})
