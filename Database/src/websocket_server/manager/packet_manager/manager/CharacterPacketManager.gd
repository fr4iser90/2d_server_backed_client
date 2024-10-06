# CharacterPacketManager.gd
extends Node

@onready var character_manager = $"../../../../../../Database/Character/CharacterManager"
@onready var response_packet_manager = $"../ResponsePacketManager"

func _ready():
	print("CharacterPacketManager initialized")

func handle_character_packet(peer_id: int, packet: Dictionary):
	var action = packet.get("action", null)
	match action:
		"fetch_character":
			var character_data = character_manager.fetch_character(packet["character_id"])
			response_packet_manager.send_response(peer_id, "character_fetch", true, {"character_data": character_data})
		"fetch_all_characters":
			var all_characters = character_manager.fetch_all_characters(packet["user_id"])
			response_packet_manager.send_response(peer_id, "fetch_all_characters", true, {"characters": all_characters})
		"create_character":
			character_manager.create_character(packet["user_id"], packet["character_name"], packet["character_class"])
			response_packet_manager.send_response(peer_id, "create_character", true)
		"update_character":
			print()
			character_manager.update_character(packet["user_id"], packet["character_id"], packet["character_data"])
			response_packet_manager.send_response(peer_id, "update_character", true)
		"delete_character":
			character_manager.delete_character(packet["character_id"])
			response_packet_manager.send_response(peer_id, "delete_character", true)
		"update_inventory":
			character_manager.update_inventory(packet["character_id"], packet["inventory_data"])
			response_packet_manager.send_response(peer_id, "update_inventory", true)
		"fetch_inventory":
			var inventory = character_manager.fetch_inventory(packet["character_id"])
			response_packet_manager.send_response(peer_id, "fetch_inventory", true, {"inventory": inventory})
		"character_position_update":
			character_manager.update_character_position(packet["character_id"], packet["position"])
			response_packet_manager.send_response(peer_id, "character_position_update", true)
		"fetch_character_position":
			var position = character_manager.fetch_character_position(packet["character_id"])
			response_packet_manager.send_response(peer_id, "fetch_character_position", true, {"position": position})
		"level_up":
			character_manager.level_up(packet["character_id"])
			response_packet_manager.send_response(peer_id, "level_up", true)
		"update_stats":
			character_manager.update_stats(packet["character_id"], packet["stats"])
			response_packet_manager.send_response(peer_id, "update_stats", true)
		_:
			print("Unknown character action: ", action)
			response_packet_manager.send_response(peer_id, "error", false, {"error_message": "Unknown character action"})
