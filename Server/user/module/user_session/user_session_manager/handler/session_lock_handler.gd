# SessionLockHandler.gd
extends Node

signal session_locked(username: String)
signal session_unlocked(username: String)

var locked_sessions: Dictionary = {}  # Holds active user sessions (username => locked state)

# Attempt to lock a session for a user by username
func lock_session(username: String) -> bool:
	if locked_sessions.has(username):
		print("User already has an active session. Username:", username)
		return false  # Session already locked for this user

	locked_sessions[username] = true
	emit_signal("session_locked", username)
	print("Session locked for user:", username)
	return true

# Unlock the session for the user by username
func unlock_session(username: String):
	if locked_sessions.has(username):
		print("Unlocking session for Username:", username)
		locked_sessions.erase(username)
		emit_signal("session_unlocked", username)
		print("Session unlocked for user:", username)

# Check if a session is locked
func is_session_locked(username: String) -> bool:
	var is_locked = locked_sessions.has(username)
	print("Checking if session is locked for user:", username, ". Locked:", is_locked)
	return is_locked
