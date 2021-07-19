extends ColorRect

onready var code_edit = $Background/Info/HBoxContainer/LobbyCode
onready var pass_edit = $Background/Info/HBoxContainer2/LobbyPass

signal joining_lobby

func _on_Cancel_pressed():
	hide()

func _on_Join_pressed():
	Server.join_lobby(int(code_edit.text), pass_edit.text)
	emit_signal("joining_lobby")
