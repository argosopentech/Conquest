extends Node

const SERVER_PORT = 1909
var SERVER_IP = "127.0.0.1"
var player_name = "player"
var my_lobby = {}
var active_lobbies = {}
var join_lobby_request_sent = false
var ask_for_lobbies_request_sent = false
var player_id = null
var player_number = null

var lobby_data = null
var reason = null

signal lobby_created_signal(lobby_data)
signal lobby_updated_signal(lobby_data, reason)
signal failed_to_join_lobby_signal(reason)
signal got_active_lobbies_signal(lobbies)
signal kicked_from_lobby_signal(reason)
signal got_message(message, sender)
signal game_started_signal()

var connected = false

func _ready():
	connect_signals()
	connect_to_server()

func connect_signals():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func disconnect_server():
	if get_tree().network_peer:
		get_tree().network_peer.close_connection()
		get_tree().network_peer = null
		connected = false

func _connected_to_server():
	print("Connected to the server: ", SERVER_IP)
	player_id = get_tree().get_network_unique_id()
	connected = true

func _connection_failed():
	print("Failed to connect to the server.")
	connected = false

func _server_disconnected():
	print("Server disconnected.")
	player_id = null
	connected = false

func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	var error = peer.create_client(SERVER_IP, SERVER_PORT)
	if error == OK:
		get_tree().network_peer = peer
	else:
		print("Error connecting to server: ", str(error))

remote func send_player_name():
	var sender_id = get_tree().get_rpc_sender_id()
	rpc_id(sender_id, "get_player_name", player_name)
	print("Sent player name")

func send_saved_player_name():
	rpc_id(1, "get_player_name", player_name)
	print("Sent player name")

func create_lobby(lobby_data):
	rpc_id(1, "create_lobby", lobby_data)

remote func lobby_created(lobby_data):
	my_lobby = lobby_data
	emit_signal("lobby_created_signal", lobby_data)

func join_lobby(lobby_code, lobby_pass):
	if join_lobby_request_sent:
		return
	rpc_id(1, "join_lobby", lobby_code, lobby_pass)
	join_lobby_request_sent = true

remote func update_lobby(lobby_data, reason = ""):
	my_lobby = lobby_data
	join_lobby_request_sent = false
	emit_signal("lobby_updated_signal", lobby_data, reason)
	print(reason)

remote func failed_to_join_lobby(reason = ""):
	join_lobby_request_sent = false
	emit_signal("failed_to_join_lobby_signal", reason)
	print(reason)

func ask_for_active_lobbies():
	if ask_for_lobbies_request_sent:
		return
	rpc_id(1, "send_active_lobbies")
	ask_for_lobbies_request_sent = true

remote func get_active_lobbies(lobbies):
	ask_for_lobbies_request_sent = false
	active_lobbies = lobbies
	emit_signal("got_active_lobbies_signal", lobbies)
	print("Got active lobbies.")

func leave_lobby():
	rpc_id(1, "leave_lobby", my_lobby.code)

func kick_player_from_lobby(lobby_code, player_id):
	rpc_id(1, "kick_player_from_lobby", lobby_code, player_id)

remote func kicked_from_lobby(reason = ""):
	print(reason)
	emit_signal("kicked_from_lobby_signal")

func send_message(lobby_code, message, sender):
	rpc_id(1, "send_message", lobby_code, message, sender)

remote func get_message(message, sender):
	print("Got message:\n", message, "\nfrom\n", sender)
	emit_signal("got_message", message, sender)

func send_node_func_call(node_path, function, parameter=null):
	rpc_id(1, "send_node_func_call", int(my_lobby.code), node_path, function, parameter)

remote func get_node_func_call(node_path, function, parameter=null):
	if parameter != null:
		get_node(node_path).call_deferred(function, parameter, true)
	else:
		if has_node(node_path):
			get_node(node_path).call(function, true)

func start_game(lobby_code):
	rpc_id(1, "start_game", lobby_code)

remote func game_started():
	print("game started")
	emit_signal("game_started_signal")
