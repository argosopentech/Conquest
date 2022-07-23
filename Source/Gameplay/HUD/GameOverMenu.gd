extends TextureRect

class_name GameoverMenu

onready var player_label = $Info/Player
onready var back_label = $Info/HMenu/Back
onready var timer = $Timer
var time = 5

func _ready():
	back_label.text = "Back to menu in 5(s)"
	if GamePlay.online:
		back_label.text = "Back to lobby in 5(s)"

func set_player_name(player_name):
	player_label.text = player_name

func play_again():
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")

func main_menu():
	get_tree().change_scene("res://Source/Main/Main.tscn")

func _on_Timer_timeout():
	time -= 1
	back_label.text = "Back to menu in " + str(time) + "(s)"
	if GamePlay.online:
		back_label.text = "Back to lobby in " + str(time) + "(s)"
	if time == 0:
		if GamePlay.online:
			get_tree().change_scene("res://Source/Gameplay/HUD/Lobby.tscn")
		else:
			get_tree().change_scene("res://Source/Main/Main.tscn")

func _on_GameoverMenu_visibility_changed():
	if visible:
		timer.start()
