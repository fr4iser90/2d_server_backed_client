# res://src/core/server_manager/InstanceMonitor.gd
extends Node  # This remains a Node

var monitored_scene: Control = null
var monitor_window: Window = null  # Window will be created dynamically
var focused_player: Node = null  # Reference to the player we want to focus on
var focused_player_peer_id: int = -1  # Store the focused player's peer_id

# Function to start monitoring a scene based on instance_key and focus on a player
func show_scene_instance_window(instance_key: String, peer_id: int):
	var instance_manager = GlobalManager.NodeManager.get_cached_node("game_world_module", "instance_manager")
	var player_movement_manager = GlobalManager.NodeManager.get_cached_node("game_player_module", "player_movement_manager")
	var instance_data = instance_manager.instances.get(instance_key, null)  # Fetch instance data
	print("instance_data: ", instance_data)

	if instance_data:
		# Load the scene and add all objects (players, mobs, NPCs)
		var scene_instance = instance_data.get("scene_instance", null)
		if not scene_instance:
			var scene_name = instance_data.get("scene_path", "")
			var resolved_scene_path = GlobalManager.SceneManager.get_scene_path(scene_name)
			var scene_resource = load(resolved_scene_path)
			scene_instance = scene_resource.instantiate() if scene_resource else null

		if scene_instance:
			monitor_window = Window.new()
			monitor_window.title = "Instance Monitor"
			monitor_window.min_size = Vector2(800, 600)
			monitor_window.popup_centered()

			var monitored_container = Control.new()
			monitored_container.add_child(scene_instance)

			# Add players, mobs, and NPCs
			_add_players(instance_data["players"], monitored_container, peer_id)
			_add_mobs(instance_data["mobs"], monitored_container)
			_add_npcs(instance_data["npcs"], monitored_container)

			monitor_window.add_child(monitored_container)
			get_tree().root.add_child(monitor_window)
			monitored_scene = monitored_container

			# Connect to the player movement signal to update the focused player's position

			if player_movement_manager:
				player_movement_manager.connect("player_position_updated", Callable(self, "_on_player_position_updated"))

		else:
			print("Error: No valid scene instance to load.")
	else:
		print("Error: Instance data not found.")

# Helper function to add players to the monitored scene
func _add_players(players_data: Array, container: Control, peer_id: int):
	for player_data in players_data:
		# Spieler-Szene laden
		var character_data = player_data["character_data"]
		print("player_data: ", player_data)
		var player_scene_path = GlobalManager.SceneManager.get_scene_path(character_data.get("name", ""))
		print("player_scene_path: ", player_scene_path)
		var player_scene = load(player_scene_path)

		if player_scene and player_scene is PackedScene:
			var player_node = player_scene.instantiate()

			# Set player's position only if the node is the correct type
			var position_data = character_data.get("last_known_position", {})
			var position = Vector2(position_data.get("x", 0), position_data.get("y", 0))
			
			# Handle 2D Nodes (specifically CharacterBody2D)
			if player_node is CharacterBody2D:
				player_node.global_position = position  # Set global_position for CharacterBody2D
			elif player_node is Node2D:
				player_node.position = position  # Set position for generic Node2D
			elif player_node is Control:
				player_node.rect_position = position  # Set position for UI nodes (Control)

			# Füge den Spieler in den Container hinzu
			container.add_child(player_node)

			# Fokus auf den Spieler setzen
			if player_data["peer_id"] == peer_id:
				focused_player = player_node
				focused_player_peer_id = peer_id
		else:
			print("Error: Could not load player scene for ", character_data.get("scene_name", "Unknown"))

# Helper function to add mobs to the monitored scene
func _add_mobs(mobs_data: Array, container: Control):
	for mob_data in mobs_data:
		# Resolve the mob's scene path
		var mob_scene_path = GlobalManager.SceneManager.get_scene_path(mob_data.get("scene_name", ""))
		var mob_scene = load(mob_scene_path)

		if mob_scene and mob_scene is PackedScene:
			var mob_node = mob_scene.instantiate()

			# Set the mob's position
			var position = mob_data.get("mob_position", Vector2())
			mob_node.position = position

			# Add the mob to the container
			container.add_child(mob_node)

# Helper function to add NPCs to the monitored scene
func _add_npcs(npcs_data: Array, container: Control):
	for npc_data in npcs_data:
		# Resolve the NPC's scene path
		var npc_scene_path = GlobalManager.SceneManager.get_scene_path(npc_data.get("scene_name", ""))
		var npc_scene = load(npc_scene_path)

		if npc_scene and npc_scene is PackedScene:
			var npc_node = npc_scene.instantiate()

			# Set the NPC's position
			var position = npc_data.get("npc_position", Vector2())
			npc_node.position = position

			# Add the NPC to the container
			container.add_child(npc_node)


# Function to update the focused player's position (based on real-time updates)
func _on_player_position_updated(peer_id: int, new_position: Vector2):
	if focused_player and peer_id == focused_player_peer_id:
		if focused_player is CharacterBody2D:
			focused_player.global_position = new_position  # Update global_position for CharacterBody2D
		elif focused_player is Node2D:
			focused_player.position = new_position  # Update position for Node2D
		elif focused_player is Control:
			focused_player.rect_position = new_position  # Update position for Control nodes
		else:
			print("Warning: Focused player node does not have a position property.")


# Function to close the monitoring window and remove the scene
func close_scene_window():
	if monitored_scene:
		monitored_scene.queue_free()  # Remove the scene
		monitored_scene = null

		if monitor_window:
			monitor_window.queue_free()  # Remove the window
			monitor_window = null

		print("Monitoring scene closed.")
	else:
		print("No scene to close.")
