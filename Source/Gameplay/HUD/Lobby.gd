extends Control

onready var name_label = $TextureRect/Info/NameLabel
onready var code_label = $TextureRect/Info/Window/Details/Code/CodeLabel
onready var players_label = $TextureRect/Info/Window/Details/Players/PlayersLabel
onready var pass_label = $TextureRect/Info/Window/Details/Pass/PassLabel
onready var players_list = $TextureRect/Info/Window/PlayersList
onready var start_button = $TextureRect/Info/HMenu3/StartGame
onready var start_margin = $TextureRect/Info/HMenu3/MarginRight
onready var chat = $TextureRect/Info/Window/Chat/ChatBox/Chat
onready var chat_box = $TextureRect/Info/Window/Chat/ChatBox
onready var chat_scroll = $TextureRect/Info/Window/Chat/ChatBox.get_v_scrollbar()
onready var message_edit = $TextureRect/Info/Window/Chat/MessageBox/Message

var player_instance_scene = preload("res://Source/Gameplay/HUD/PlayerListInstance.tscn")
var message_instance_scene = preload("res://Source/Gameplay/HUD/MessageInstance.tscn")
var max_scroll_length = 0

func _ready():
	check_for_previous_messages()
	connect_signals()
	setup_lobby_ui()
	max_scroll_length = chat_scroll.max_value

func check_for_previous_messages():
	if Server.lobby_data:
		if Server.reason:
			start_button.hide()
			lobby_updated(Server.lobby_data, Server.reason)

func connect_signals():
	chat_scroll.connect("changed", self, "scroll_chat_box")
	connect_server_signals()

func connect_server_signals():
	Server.connect("lobby_updated_signal", self, "lobby_updated")
	Server.connect("kicked_from_lobby_signal", self, "kicked_from_lobby")
	Server.connect("got_message", self, "got_message")
	Server.connect("game_started_signal", self, "start_game")

func setup_lobby_ui():
	name_label.text = str(Server.my_lobby.name)
	code_label.text = str(Server.my_lobby.code)
	players_label.text = str(Server.my_lobby.current_players) + "/" + str(Server.my_lobby.max_players)
	pass_label.text = str(Server.my_lobby.pass)
	instance_player_list()

func instance_player_list():
	for child in players_list.get_children():
		if child is PlayerListInstance:
			child.queue_free()
	for i in Server.my_lobby.players:
		var player_instance = player_instance_scene.instance()
		player_instance.set_name(str(Server.my_lobby.players[i].id))
		players_list.add_child(player_instance)
		player_instance.color_rect.color = Server.my_lobby.players[i].color
		player_instance.name_label.text = Server.my_lobby.players[i].name
		if Server.my_lobby.players[i]["host"]:
			player_instance.kick_button.hide()
			start_button.show()
			start_margin.show()
		if !Server.my_lobby.players[Server.player_id]["host"]:
			player_instance.kick_button.hide()
			start_button.hide()
			start_margin.hide()
		if Server.my_lobby.players[i].id == Server.player_id:
			player_instance.name_label.set("custom_colors/font_color", Color.orangered)
			Server.player_number = i

func kicked_from_lobby(reason = ""):
	print(reason)
	get_tree().change_scene("res://Source/Main/Main.tscn")

func write_server_message(message):
	var message_instance = message_instance_scene.instance()
	chat.add_child(message_instance)
	message_instance.message_label.text = message
	message_instance.color_rect.hide()

func got_message(message, sender):
	var message_instance = message_instance_scene.instance()
	chat.add_child(message_instance)
	message_instance.message_label.text = message
	message_instance.sender_label.text = sender.name + ": "
	message_instance.sender_label.set("custom_colors/font_color", sender.color)
	message_instance.color_rect.color = sender.color

func scroll_chat_box():
	if max_scroll_length != chat_scroll.max_value:
		chat_box.scroll_vertical = chat_scroll.max_value
		max_scroll_length = chat_scroll.max_value

func lobby_updated(lobby_data, reason):
	setup_lobby_ui()
	write_server_message(reason)
	if Server.lobby_data:
		Server.lobby_data = null
		Server.reason = null

func _on_Cancel_pressed():
	Server.leave_lobby()
	get_tree().change_scene("res://Source/Main/Main.tscn")

func _on_Send_pressed():
	var code = int(code_label.text)
	var message = message_edit.text
	var sender = Server.my_lobby.players[Server.player_number]
	Server.send_message(code, message, sender)
	message_edit.text = ""

func _on_Message_text_entered(new_text):
	_on_Send_pressed()

func _on_StartGame_pressed():
	Server.start_game(int(code_label.text))

func start_game():
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")
