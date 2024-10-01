# UserModel.gd
extends Node  # You can also use `extends Node` if necessary for your project

class_name UserModel

# Define user attributes
var username: String = ""
var password: String = ""
var character_slots: int = 3
var characters: Array = []
var shared_stash: Dictionary = {}
var guilds: Array = []
var selected_character: Dictionary = {}
var created_at: String = ""
