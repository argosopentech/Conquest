extends Control

onready var name_label = $TextureRect/Info/NameLabel
onready var code_label = $TextureRect/Info/Window/Details/Code/CodeLabel
onready var players_label = $TextureRect/Info/Window/Details/Players/PlayersLabel
onready var pass_label = $TextureRect/Info/Window/Details/Pass/PassLabel
onready var players_list = $TextureRect/Info/Window/PlayersList
onready var start_button = $TextureRect/Info/HMenu3/StartGame
onready var start_margin = $TextureRect/Info/HMenu3/MarginRight

var player_instance_scene = preload("res://Source/Gameplay/HUD/PlayerListInstance.tscn")

func _ready():
	Server.connect("lobby_updated_signal", self, "lobby_updated")
	Server.connect("kicked_from_lobby_signal", self, "kicked_from_lobby")
	setup_lobby_ui()

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
	for i in range(Server.my_lobby.current_players):
		var player_instance = player_instance_scene.instance()
		player_instance.set_name(str(Server.my_lobby.players[i].id))
		players_list.add_child(player_instance)
		player_instance.color_rect.color = Server.my_lobby.players[i].color
		player_instance.name_label.text = Server.my_lobby.players[i].name
		if i == 0:
			player_instance.kick_button.hide()
		if Server.my_lobby.players[0].id != Server.player_id:
			player_instance.kick_button.hide()
			start_button.hide()
			start_margin.hide()
		if Server.my_lobby.players[i].id == Server.player_id:
			player_instance.name_label.set("custom_colors/font_color", Color.orangered)

func kicked_from_lobby(reason = ""):
	print(reason)
	get_tree().change_scene("res://Source/Main/Main.tscn")

func lobby_updated(lobby_data, reason):
	setup_lobby_ui()

func _on_Cancel_pressed():
	Server.leave_lobby()
	get_tree().change_scene("res://Source/Main/Main.tscn")
