# TriggerRoomChangeHandler.gd
extends Node

func handle_trigger_entry(peer_id: int, trigger_name: String, position: Vector2):
	print("Room change entry for peer:", peer_id, "trigger:", trigger_name, "at position:", position)

func handle_trigger_exit(peer_id: int, trigger_name: String):
	print("Room change exit for peer:", peer_id, "trigger:", trigger_name)
