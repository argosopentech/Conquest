extends VBoxContainer

class_name LobbySearchInstance

onready var code_label = $HBox/Code
onready var name_label = $HBox/Name
onready var players_label = $HBox/Players
onready var pass_edit = $HBox/Password
onready var join_button = $HBox/Join

signal joining

func _on_Join_pressed():
	Server.join_lobby(int(code_label.text), pass_edit.text)
	emit_signal("joining")

func disable_join_button():
	join_button.disabled = true

func enable_join_button():
	join_button.disabled = false
