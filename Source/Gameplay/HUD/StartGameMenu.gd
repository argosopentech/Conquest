extends TextureRect

class_name StartGameMenu

#onready var players = $Info/PlayersRange

func cancel():
	if get_parent() is ColorRect:
		get_parent().hide()

func start_game():
	#GamePlay.players = players.value
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")

func _on_Join_pressed():
	get_tree().change_scene("res://Source/Gameplay/HUD/JoinGameMenu.tscn")

func _on_Create_pressed():
	get_tree().change_scene("res://Source/Gameplay/HUD/HostGameMenu.tscn")
