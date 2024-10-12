extends Node

var current_state = null
var player_node = null
var enet_client_manager = null
var player_peer_id = -1
var is_initialized = false

func initialize():
	if is_initialized:
		return
	is_initialized = true
	print("_ready called, process enabled")
	enet_client_manager = GlobalManager.NodeManager.get_cached_node("NetworkGameModule", "NetworkENetClientManager")
	player_peer_id = enet_client_manager.get_peer_id()
	set_process(true)  # Ensure that _process runs every frame

# Set the player node and determine the state based on peer_id
func set_player(player: Node, peer_id: int):
	print("Setting player node: ", player)
	player_node = player

	# Attach the movement state handler only if this is the local player's peer_id
	if enet_client_manager.get_peer_id() == peer_id:
		print("Attaching MovementStateHandler to the player node directly.")
		if not player_node.has_method("enter_state"):
			player_node.set_script(load("res://src/game/player_manager/player_state_machine_manger/handler/MovementStateHandler.gd"))
			player_node.call("enter_state", player_node, peer_id)
		else:
			print("MovementStateHandler already attached.")
	
	# Start the state machine by entering the initial state
	if current_state != null:
		current_state.enter_state(player_node)
	else:
		print("Current state is null, state machine not started")

# Initialize the state machine with a starting state
func initialize_state(initial_state: String):
	print("Initializing state machine with state: ", initial_state)
	if initial_state == "movement":
		var movement_state = load("res://src/game/player_manager/player_state_machine_manger/handler/MovementStateHandler.gd").new()
		set_state(movement_state)
		movement_state.player_peer_id = player_peer_id
		
# Change state
func set_state(new_state):
	print("Changing state to: ", new_state)
	if current_state != null:
		print("Exiting current state")
		current_state.exit_state()
	current_state = new_state
	if current_state != null and player_node != null:
		print("Entering new state")
		current_state.enter_state(player_node, enet_client_manager.get_peer_id())
	else:
		print("Player node is null when trying to enter state.")

# Process the current state, this is called every frame
func _process(delta):
	if current_state != null:
		#print("Updating current state")
		current_state.update_state(delta)
	else:
		#print("No current state to update")
		pass
