extends VMenu

class_name MainMenu

onready var quit_confirm_menu = $Overlay/QuitConfirm
onready var quit_confirm_vmenu = $Overlay/QuitConfirm/ColorRect/MarginContainer/VMenu

func _ready():
	quit_confirm_menu.hide()

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		quit()

func play():
	get_tree().change_scene("res://Source/Gameplay/Game/Game.tscn")

func options():
	pass

func quit():
	quit_confirm_menu.show()
	quit_confirm_vmenu.grab_focus_on_index_child()
	set_process_unhandled_input(false)

func quit_confirm():
	get_tree().quit()

func quit_cancel():
	quit_confirm_menu.hide()
	set_process_unhandled_input(true)
	grab_focus_on_index_child()
