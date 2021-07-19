extends Control

onready var name_label = $TextureRect/Info/NameLabel
onready var code_label = $TextureRect/Info/Window/Details/Code/CodeLabel
onready var players_label = $TextureRect/Info/Window/Details/Players/PlayersLabel
onready var pass_label = $TextureRect/Info/Window/Details/Pass/PassLabel

func _ready():
	Server.connect("lobby_updated_signal", self, "lobby_updated")
	setup_lobby_ui()

func setup_lobby_ui():
	name_label.text = str(Server.my_lobby.name)
	code_label.text = str(Server.my_lobby.code)
	players_label.text = str(Server.my_lobby.current_players) + "/" + str(Server.my_lobby.max_players)
	pass_label.text = str(Server.my_lobby.pass)

func lobby_updated(lobby_data, reason):
	setup_lobby_ui()

func _on_Cancel_pressed():
	Server.leave_lobby()
	get_tree().change_scene("res://Source/Main/Main.tscn")
