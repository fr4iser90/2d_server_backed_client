extends Node

var routes: Dictionary = {}  # Routes dictionary with full paths as keys
var short_name_to_path: Dictionary = {}  # Map short names to full paths

var routes_api_url = GlobalManager.GlobalConfig.get_backend_url() + "/api/utility/get_all_routes"
var http_request: HTTPRequest
var is_initialized = false  # Flag to prevent double initialization

func initialize():
	if is_initialized:
		return

	# Set up HTTPRequest and connect the signal, but do not fetch the URL yet
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", Callable(self, "_on_routes_fetched"))

	is_initialized = true
	GlobalManager.DebugPrint.debug_info("BackendRoutesManager initialized, waiting for backend connection.", self)

func fetch_routes():
	if http_request == null:
		await initialize()  # Wait until HTTPRequest is correctly initialized
	var err = http_request.request(routes_api_url)
	if err != OK:
		GlobalManager.DebugPrint.debug_error("Failed to fetch routes, error code: " + str(err), self)
	else:
		GlobalManager.DebugPrint.debug_info("Fetching routes from backend...", self)

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
			
			GlobalManager.DebugPrint.debug_info("Routes fetched successfully.", self)
		else:
			GlobalManager.DebugPrint.debug_error("Failed to parse routes JSON.", self)
	else:
		GlobalManager.DebugPrint.debug_error("Failed to fetch routes, response code: " + str(response_code), self)

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
