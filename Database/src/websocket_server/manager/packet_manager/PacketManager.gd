# PacketManager.gd
extends Node

@onready var global_manager = $"../../../../Database/Global/GlobalManager"
@onready var server_packet_manager = $Manager/ServerPacketManager
@onready var user_packet_manager = $Manager/UserPacketManager
@onready var character_packet_manager = $Manager/CharacterPacketManager
@onready var response_packet_manager = $Manager/ResponsePacketManager


# Dictionary to hold dynamic handler functions
var packet_handlers = {}

func _ready():
	# Register handlers for global, server, and user packets
	packet_handlers = {
		"global": Callable(global_manager, "handle_global_packet"),   # Global operations
		"server": Callable(server_packet_manager, "handle_server_packet"),   # Server-specific operations
		"user": Callable(user_packet_manager, "handle_user_packet"),         # User-specific operations
		"character": Callable(character_packet_manager, "handle_character_packet"),         # User-specific operations
	}

# Main function to route packets based on type
func handle_packet(peer_id: int, packet: Dictionary):
	var packet_type = packet.get("category", null)  # Using "category" to route to the correct manager
	if packet_handlers.has(packet_type):
		packet_handlers[packet_type].call(peer_id, packet)
	else:
		print("Unrecognized packet type: ", packet_type)
