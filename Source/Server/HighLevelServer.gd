extends Node
class_name HighLevelServer

var client = NetworkedMultiplayerENet.new()
var response_handler = null

signal server_connected(client_id)
signal server_disconnected

func set_response_handler(new_handler):
	response_handler = new_handler

func connect_to_server(server_address="127.0.0.1", server_port=1909, max_players=2000):
	if client.create_client(server_address, server_port) == OK:
		connect_server_signals()
		get_tree().network_peer = client
	else:
		print("Couldn't connect to the server.")
		
func connect_server_signals():
	if get_tree().is_connected("connected_to_server", self, "connected_to_server"): return
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("connection_failed", self, "disconnected_from_server")
	get_tree().connect("server_disconnected", self, "disconnected_from_server")

func connected_to_server():
	print("Connected to the server.")
	emit_signal("server_connected", get_tree().get_network_unique_id())

func disconnected_from_server():
	print("Disconnected from server.")
	emit_signal("server_disconnected")

remote func received_data_from_server(method_info):
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

func send_data_to_server(method, data=null):
	var method_info = {"purpose": "request", "method": method, "data": data}
	rpc_id(1, "received_data_from_client", method_info)

func disconnect_from_server():
	disconnect_server_signals()
	client.close_connection()

func disconnect_server_signals():
	if !get_tree().is_connected("connected_to_server", self, "connected_to_server"): return
	get_tree().disconnect("connected_to_server", self, "connected_to_server")
	get_tree().disconnect("connection_failed", self, "disconnected_from_server")
	get_tree().disconnect("server_disconnected", self, "disconnected_from_server")

