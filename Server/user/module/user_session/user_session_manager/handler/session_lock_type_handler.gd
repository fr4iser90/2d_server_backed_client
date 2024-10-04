# res://src/user/user_session_manager/handler/session_lock_type_handler.gd
extends Node

enum LockType { USER, CHARACTER }
var current_lock_type = LockType.USER

signal lock_type_changed(lock_type: LockType)

# Set the current lock type (User or Character)
func set_lock_type(lock_type: LockType):
	if lock_type != current_lock_type:
		current_lock_type = lock_type
		emit_signal("lock_type_changed", lock_type)
		print("Lock type changed to:", "User" if lock_type == LockType.USER else "Character")


# Get the current lock type
func get_lock_type() -> LockType:
	return current_lock_type
