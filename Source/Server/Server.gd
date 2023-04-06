extends Node

var SERVER_PORT = 1909
var local_ip = "127.0.0.1" #"conquestgame.online"
var conquest_official_ws_address = "conquestgame.online"
var SERVER_IP = conquest_official_ws_address
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

var server = null
var high_level_server = preload("res://Source/Server/HighLevelServer.tscn")
var web_sockets_server = preload("res://Source/Server/WebSocketsServer.tscn")

export var should_use_web_sockets_server = true

var is_local = false

signal server_connected
signal server_disconnected

func _ready():
	if is_local:
		SERVER_IP = local_ip
	connect_to_server()

func connect_to_server():
	if is_running_on_the_web() or should_use_web_sockets_server:
		server = web_sockets_server.instance()
	else:
		server = high_level_server.instance()
	connect_connection_signals()
	server.set_response_handler(self)
	add_child(server)
	server.connect_to_server(SERVER_IP)

func is_running_on_the_web():
	return OS.get_name() == "HTML5"

func connect_connection_signals():
	if server.is_connected("server_connected", self, "server_connected"): return
	server.connect("server_connected", self, "server_connected")
	server.connect("server_disconnected", self, "server_disconnected")

func server_connected(new_player_id):
	if not GamePlay.online: return
	print("Connected to the server: ", SERVER_IP)
	player_id = new_player_id
	connected = true
	emit_signal("server_connected")

func server_disconnected():
	if not GamePlay.online: return
	print("Server disconnected.")
	player_id = null
	connected = false
	emit_signal("server_disconnected")

func set_player_id(new_player_id):
	player_id = new_player_id

func send_player_name():
	if not GamePlay.online: return
	server.send_data_to_server("set_player_name", {"player_name": player_name})
	print("Sent player name")

func create_lobby(lobby_data):
	if not GamePlay.online: return
	server.send_data_to_server("create_game_lobby", lobby_data)

func game_lobby_created(data):
	if not GamePlay.online: return
	my_lobby = data["lobby_data"]
	player_number = data["player_number"]
	emit_signal("lobby_created_signal", lobby_data)

func join_lobby(lobby_code, lobby_pass):
	if not GamePlay.online: return
	if join_lobby_request_sent: return
	var lobby_auth_info = {"lobby_code": lobby_code, "lobby_pass": lobby_pass}
	server.send_data_to_server("join_game_lobby", lobby_auth_info)
	join_lobby_request_sent = true

func update_game_lobby(data):
	if not GamePlay.online: return
	my_lobby = data["lobby"]
	GamePlay.players_data = my_lobby.players
	var reason = data["reason"]
	join_lobby_request_sent = false
	if data.has("player_number"):
		player_number = data["player_number"]
	emit_signal("lobby_updated_signal", my_lobby, reason)
	print(reason)

func failed_to_join_game_lobby(reason = ""):
	if not GamePlay.online: return
	join_lobby_request_sent = false
	emit_signal("failed_to_join_lobby_signal", reason)
	print(reason)

func ask_for_active_lobbies():
	if not GamePlay.online: return
	if ask_for_lobbies_request_sent:
		return
	server.send_data_to_server("send_active_game_lobbies")
	ask_for_lobbies_request_sent = true

func get_active_lobbies(lobbies=null):
	if not GamePlay.online: return
	ask_for_lobbies_request_sent = false
	active_lobbies = lobbies
	if !lobbies: return
	emit_signal("got_active_lobbies_signal", lobbies)
	print("Got active lobbies.")

func leave_lobby():
	if not GamePlay.online: return
	server.send_data_to_server("leave_game_lobby", {"lobby_code": my_lobby.code})

func kick_player_from_lobby(lobby_code, player_id):
	if not GamePlay.online: return
	var data = {
		"kicked_player_id": player_id,
		"lobby_code": lobby_code
	}
	server.send_data_to_server("kick_player_from_game_lobby", data)

func kicked_from_lobby(reason = ""):
	if not GamePlay.online: return
	print(reason)
	emit_signal("kicked_from_lobby_signal")

func send_message(lobby_code, message, sender):
	if not GamePlay.online: return
	var data = {
		"lobby_code": lobby_code,
		"message": message,
		"sender": sender
	}
	server.send_data_to_server("send_message_in_game_lobby", data)

func get_message(message_info):
	if not GamePlay.online: return
	var sender = message_info["sender"]
	var message = message_info["message"]
	print("Got message:\n", message, "\nfrom\n", sender)
	emit_signal("got_message", message, sender)

func send_node_func_call(node_path, function, parameter=null):
	if not GamePlay.online: return
	var data = {
		"lobby_code": int(my_lobby.code),
		"parameter": parameter,
		"method": function,
		"node_path": node_path
	}
	server.send_data_to_server("send_node_method_call", data)

func get_node_method_call(data):
	if not GamePlay.online: return
	var parameter = data["parameter"]
	var node_path = data["node_path"]
	var method = data["method"]
	if parameter != null:
		get_node(node_path).call_deferred(method, parameter, true)
	else:
		if has_node(node_path):
			get_node(node_path).call(method, true)

func start_game(lobby_code):
	if not GamePlay.online: return
	server.send_data_to_server("start_the_game", {"lobby_code": lobby_code})

func game_started():
	if not GamePlay.online: return
	print("game started")
	emit_signal("game_started_signal")

func disconnect_server():
	if not GamePlay.online: return
	GamePlay.players_data = GamePlay.players_data_template
	server.disconnect_from_server()
	disconnect_connection_signals()
	server.queue_free()
	connected = false

func disconnect_connection_signals():
	if !server.is_connected("server_connected", self, "server_connected"): return
	server.disconnect("server_connected", self, "server_connected")
	server.disconnect("server_disconnected", self, "server_disconnected")
