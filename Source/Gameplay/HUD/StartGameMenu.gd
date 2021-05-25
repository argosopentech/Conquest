extends TextureRect

class_name StartGameMenu

onready var players = $Info/PlayersRange

func cancel():
	if get_parent() is ColorRect:
		get_parent().hide()

func start_game():
	GamePlay.players = players.value
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")
