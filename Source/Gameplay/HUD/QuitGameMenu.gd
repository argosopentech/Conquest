extends TextureRect

class_name QuitGameMenu

func cancel():
	GamePlay.game.overlay.hide()
	hide()

func quit_game():
	get_tree().change_scene("res://Source/Main/Main.tscn")
