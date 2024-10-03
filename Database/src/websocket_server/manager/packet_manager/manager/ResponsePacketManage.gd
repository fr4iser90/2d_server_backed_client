extends Node

@onready var web_socket_manager = $"../../.."


# Configuration Variables
var enable_logging: bool = true  # Controls whether logging is enabled
var enable_compression: bool = false  # Controls whether data compression is enabled
var enable_timeout_handling: bool = true  # Controls whether timeout handling is enabled
var enable_queuing: bool = true  # Controls whether response queuing is enabled

# Queues and timeouts
var response_queues = {}  # To queue responses for peers
var response_timeouts = {}  # To manage response timeouts for peers

# Sends a success or failure response
func send_response(peer_id: int, response_type: String, success: bool, data: Dictionary = {}, log_message: String = ""):
	var status = "success" if success else "failed"
	var response_data = {
		"type": response_type,
		"status": status
	}
	# Merge additional data into the response
	for key in data.keys():
		response_data[key] = data[key]

	# Log the response if logging is enabled
	if enable_logging:
		_log_response(peer_id, response_type, success, log_message)

	# Queue the response if queuing is enabled, else send immediately
	if enable_queuing:
		queue_response(peer_id, response_data)
		process_response_queue(peer_id)
	else:
		_send_json_to_peer(peer_id, response_data)

# Logs errors or success messages
func _log_response(peer_id: int, response_type: String, success: bool, message: String = ""):
	var status = "SUCCESS" if success else "FAILED"
	var log_message = "Response [" + response_type + "] for Peer: " + str(peer_id) + " Status: " + status
	if message != "":
		log_message += " | Message: " + message
	print(log_message)

# Compresses data before sending it (if enabled)
func _compress_data(data: Dictionary) -> PackedByteArray:
	if enable_compression:
		var json_str = JSON.stringify(data)
		var byte_data = json_str.to_utf8_buffer()
		var compressed_data = byte_data.compress(FileAccess.COMPRESSION_ZSTD)
		return compressed_data
	else:
		return JSON.stringify(data).to_utf8_buffer()

# Sends JSON data to a specific peer (compressed if enabled)
func _send_json_to_peer(peer_id: int, data: Dictionary):
	var peers_info = web_socket_manager.peers_info
	var websocket_multiplayer_peer = web_socket_manager.websocket_multiplayer_peer

	if peer_id in peers_info:
		var compressed_data = _compress_data(data)
		websocket_multiplayer_peer.set_target_peer(peer_id)
		websocket_multiplayer_peer.put_packet(compressed_data)
		print("sending data: ", JSON.stringify(data), " to peer ID: ", peer_id)

# Queues a response for a peer (if queuing is enabled)
func queue_response(peer_id: int, data: Dictionary):
	if not response_queues.has(peer_id):
		response_queues[peer_id] = []
	response_queues[peer_id].append(data)

# Processes and sends the next queued response
func process_response_queue(peer_id: int):
	if response_queues.has(peer_id) and response_queues[peer_id].size() > 0:
		var next_response = response_queues[peer_id].pop_front()
		_send_json_to_peer(peer_id, next_response)

# Sets a timeout for a specific peer_id (if timeout handling is enabled)
func set_response_timeout(peer_id: int, timeout_duration: float, callback: Callable):
	if enable_timeout_handling:
		response_timeouts[peer_id] = Timer.new()
		response_timeouts[peer_id].set_wait_time(timeout_duration)
		response_timeouts[peer_id].one_shot = true
		response_timeouts[peer_id].connect("timeout", callback)
		add_child(response_timeouts[peer_id])
		response_timeouts[peer_id].start()

# Clears the timeout once the response is successfully sent/received
func clear_response_timeout(peer_id: int):
	if response_timeouts.has(peer_id):
		response_timeouts[peer_id].stop()
		remove_child(response_timeouts[peer_id])
		response_timeouts.erase(peer_id)

# Sends an initial response that the request is being processed
func send_processing_response(peer_id: int, response_type: String):
	var response_data = {
		"type": response_type,
		"status": "processing"
	}
	_send_json_to_peer(peer_id, response_data)
