# res://src/autoloads/global_config.gd (Server)
extends Node

# Server-specific configuration
var BACKEND_IP_DNS = "http://localhost"  # Default backend IP/DNS (can be changed dynamically)
var BACKEND_PORT = "3000"                # Default backend port
var SERVER_VALIDATION_KEY = "your_server_key_here"  # Server validation key for backend auth
var SERVER_PORT = "9997"  # Default port for the server to run on

func _ready():
	print("Autoload: GlobalConfig initialized")

# Function to build the full Backend URL dynamically
func get_backend_url() -> String:
	return "%s:%s" % [BACKEND_IP_DNS, BACKEND_PORT]

# Function to set the Backend IP/DNS
func set_backend_ip_dns(new_ip_dns: String):
	BACKEND_IP_DNS = new_ip_dns

# Function to get the Backend IP/DNS
func get_backend_ip_dns() -> String:
	return BACKEND_IP_DNS

# Function to set the Backend Port
func set_backend_port(new_backend_port: int):
	BACKEND_PORT = new_backend_port

# Function to get the Backend Port
func get_backend_port() -> int:
	return BACKEND_PORT

# Function to set the Server Validation Key
func set_server_validation_key(new_key: String):
	SERVER_VALIDATION_KEY = new_key

# Function to get the Server Validation Key
func get_server_validation_key() -> String:
	return SERVER_VALIDATION_KEY

# Function to set the Server Port
func set_server_port(new_server_port: int):
	SERVER_PORT = new_server_port

# Function to get the Server Port
func get_server_port() -> int:
	return SERVER_PORT
