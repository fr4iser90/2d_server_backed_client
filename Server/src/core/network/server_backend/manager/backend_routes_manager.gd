# res://src/core/network/backend_routes_manager.gd (Server)
extends Node

var routes: Dictionary = {}  # Routes dictionary with full paths as keys
var short_name_to_path: Dictionary = {}  # Map short names to full paths

var routes_api_url = GlobalManager.GlobalConfig.get_backend_url() + "/api/utility/get_all_routes"
var http_request: HTTPRequest
var is_initialized = false  # Flag zur Verhinderung von Doppelinitialisierung

func initialize():
	if is_initialized:
		print("BackendRoutesManager already initialized. Skipping.")
		return

	# Setze nur den HTTPRequest auf und verbinde das Signal, aber hole die URL noch nicht
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_routes_fetched"))

	is_initialized = true
	print("BackendRoutesManager initialized, waiting for backend connection.")

func fetch_routes():
	if http_request == null:
		await initialize()  # Warten bis die HTTPRequest korrekt initialisiert wurde
	var err = http_request.request(routes_api_url)
	if err != OK:
		print("Failed to fetch routes, error code: ", err)
	else:
		print("Fetching routes from backend...")

func _on_routes_fetched(result: int, response_code: int, headers: Array, body: PackedByteArray):
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		if parse_result == OK:
			var data = json.get_data()
			for item in data:
				var path = item["path"]
				routes[path] = item  # Use full path as key
				
				# Extract the last part as short name
				var short_name = _get_short_name(path)
				short_name_to_path[short_name] = path
			#print("Routes fetched successfully: ", routes)
			#print("Short routes to paths mapping: ", short_name_to_path)  # Print short routes
		else:
			print("Failed to parse routes JSON.")
	else:
		print("Failed to fetch routes, response code: ", response_code)

# Access method to get a route by short name or full path
func get_route(route_name: String) -> Dictionary:
	# Try to find by full path or short name
	if routes.has(route_name):
		return routes[route_name]
	if short_name_to_path.has(route_name):
		return routes[short_name_to_path[route_name]]
	return {}

# Utility method to get the last part of the path
func _get_short_name(path: String) -> String:
	# Remove the '/api' prefix if it exists
	if path.begins_with("/api"):
		path = path.replace("/api", "")
	return path  # Return the rest of the path unchanged

