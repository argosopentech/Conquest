extends VBoxContainer

class_name PlayerListInstance

onready var color_rect = $Details/Color
onready var name_label = $Details/Name
onready var kick_button = $Details/Kick

func _on_Kick_pressed():
	Server.kick_player_from_lobby(Server.my_lobby.code, int(name))
