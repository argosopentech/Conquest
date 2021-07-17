extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 1909
var player_name = "player"

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

remote func send_player_data():
	var sender_id = get_tree().get_rpc_sender_id()
	rpc_id(sender_id, "get_player_data", player_name)
