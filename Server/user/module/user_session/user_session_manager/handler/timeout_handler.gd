# res://src/user/user_session_manager/handler/timeout_handler.gd
extends Node

signal session_timeout(peer_id: int)

var session_timeout_limit = 600  # Time limit in seconds before a session times out
var last_activity_time: Dictionary = {}  # Holds the last activity timestamp for each session

# Update the last activity time for a peer
func update_activity(peer_id: int):
	last_activity_time[peer_id] = Time.get_unix_time_from_system()
	print("Activity updated for peer_id:", peer_id)

# Check for session timeouts
func check_for_timeouts():
	var current_time = Time.get_unix_time_from_system()
	for peer_id in last_activity_time.keys():
		var last_activity = last_activity_time[peer_id]
		if current_time - last_activity > session_timeout_limit:
			print("Session timeout for peer_id:", peer_id)
			emit_signal("session_timeout", peer_id)
			last_activity_time.erase(peer_id)
