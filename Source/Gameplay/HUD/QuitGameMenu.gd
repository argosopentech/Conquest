extends TextureRect

class_name QuitGameMenu

func cancel():
	GamePlay.game.overlay.hide()
	hide()

func quit_game():
	if get_owner().name == "Game" and GamePlay.online:
		Server.leave_lobby()
	get_tree().change_scene("res://Source/Main/Main.tscn")
