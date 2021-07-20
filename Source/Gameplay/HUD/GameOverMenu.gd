extends TextureRect

class_name GameoverMenu

onready var player_label = $Info/Player
onready var back_label = $Info/HMenu/Back
onready var timer = $Timer
var time = 5

func set_player_name(player_name):
	player_label.text = player_name

func play_again():
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")

func main_menu():
	get_tree().change_scene("res://Source/Main/Main.tscn")

func _on_Timer_timeout():
	time -= 1
	back_label.text = "Back to lobby in " + str(time) + "(s)"
	if time == 0:
		get_tree().change_scene("res://Source/Gameplay/HUD/Lobby.tscn")

func _on_GameoverMenu_visibility_changed():
	if visible:
		timer.start()
