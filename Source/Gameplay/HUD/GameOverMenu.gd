extends TextureRect

class_name GameoverMenu

onready var player_label = $Info/Player

func set_player_name(player_name):
	player_label.text = player_name

func play_again():
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")

func main_menu():
	get_tree().change_scene("res://Source/Main/Main.tscn")
