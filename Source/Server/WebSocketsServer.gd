extends Node
class_name WebSocketsServer

var client = WebSocketClient.new()
var response_handler = null

signal server_connected(client_id)
signal server_disconnected()

func _ready():
	set_process(false)

func set_response_handler(new_handler):
	response_handler = new_handler

func connect_to_server(server_address="localhost", server_port=9080, max_players=2000):
	if client.connect_to_url("ws://" + server_address + ":" + str(server_port)) == OK:
		connect_server_signals()
		set_process(true)
	else:
		set_process(false)

func connect_server_signals():
	if client.is_connected("connection_established", self, "connected_to_server"):
		return
	client.connect("connection_established", self, "connected_to_server")
	client.connect("connection_closed", self, "disconnected_from_server")
	client.connect("connection_error", self, "disconnected_from_server")
	client.connect("data_received", self, "received_data_from_server")

func connected_to_server(protocol=""):
	print("Connected to the server.")
	emit_signal("server_connected", client.get_unique_id())

func disconnected_from_server(was_clean=false):
	print("Disconnected from the server.")
	emit_signal("server_disconnected")

func received_data_from_server():
	var method_info = client.get_peer(1).get_var()
	print("Just received data from server: %s" % [method_info])
	process_method_info(method_info)

func process_method_info(method_info):
	if !response_handler: return
	if method_info is Dictionary and method_info.has("purpose") and method_info["purpose"] == "response":
		if response_handler.has_method(method_info["method"]):
			if method_info["data"]:
				response_handler.call_deferred(method_info["method"], method_info["data"])
			else:
				response_handler.call_deferred(method_info["method"])

func _process(_delta):
	client.poll()

func send_data_to_server(method, data=null):
	var method_info = {"purpose": "request", "method": method, "data": data}
	client.get_peer(1).put_var(method_info, true)

func disconnect_from_server():
	disconnect_server_signals()
	client.disconnect_from_host()

func disconnect_server_signals():
	if !client.is_connected("connection_closed", self, "_closed"):
		return
	client.disconnect("connection_closed", self, "disconnected_from_server")
	client.disconnect("connection_error", self, "disconnected_from_server")
	client.disconnect("connection_established", self, "connected_to_server")
	client.disconnect("data_received", self, "received_data_from_server")
