# SceneTransitionManager.gd
extends Node

var current_scene: PackedScene
var player

# Funktion zum Anfordern des Szenenwechsels vom Server
func request_scene_transition(peer_id: int):
	rpc_id(1, "server_request_scene_transition", peer_id)

# Diese Funktion wird vom Server aufgerufen, um den Client-Szenenwechsel zu verarbeiten
remote func client_transition_to_scene(scene_path: String, spawn_position: Vector2):
	GlobalManager.DebugPrint.debug_info("Transitioning to scene: " + scene_path, self)
	
	# Lade die neue Szene
	var new_scene = load(scene_path).instance()
	get_tree().root.add_child(new_scene)
	
	# Entferne die alte Szene
	if current_scene != null:
		current_scene.queue_free()
	current_scene = new_scene

	# Spieler an der neuen Position spawnen
	if player != null:
		player.position = spawn_position
	else:
		player = get_node("Player")
		player.position = spawn_position

	GlobalManager.DebugPrint.debug_info("Player spawned at: " + str(spawn_position), self)

