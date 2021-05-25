extends Control

class_name Main

func _ready():
	setup()

func setup():
	setup_music()

func setup_music():
	GamePlay.set_music_volume(GamePlay.main_menu_volume)

func options_saved():
	setup_music()
