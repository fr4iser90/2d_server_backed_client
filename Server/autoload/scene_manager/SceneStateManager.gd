# res://src/core/autoloads/scene_manager/SceneStateManager.gd
extends Node

# Function to print the current scene tree structure
func print_tree_structure():
	print("Printing current tree structure:")
	get_tree().root.print_tree_pretty()
