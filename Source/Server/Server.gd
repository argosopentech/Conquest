extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 1909
var player_name = "player"
var my_lobby = {}
var active_lobbies = {}

func _ready():
	connect_signals()
	connect_to_server()

func connect_signals():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connection_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _connected_to_server():
	print("Connected to the server.")

func _connection_failed():
	print("Failed to connect to the server.")

func _server_disconnected():
	print("Server disconnected.")

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

func create_lobby(lobby_data):
	rpc_id(1, "create_lobby", lobby_data)

remote func lobby_created(lobby_data):
	my_lobby = lobby_data

func join_lobby(lobby_code, lobby_pass):
	rpc_id(1, "join_lobby", lobby_code, lobby_pass)

remote func update_lobby(lobby_data, reason = ""):
	my_lobby = lobby_data
	print(reason)

remote func failed_to_join_lobby(reason = ""):
	print(reason)

func ask_for_active_lobbies():
	rpc_id(1, "send_active_lobbies")

remote func get_active_lobbies(lobbies):
	active_lobbies = lobbies
	print("Got active lobbies.")
