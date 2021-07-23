extends VMenu

class_name MainMenu

onready var quit_confirm_menu = $Overlay/QuitConfirm
onready var quit_confirm_vmenu = $Overlay/QuitConfirm/ColorRect/MarginContainer/VMenu
onready var start_game_overlay = $Overlay/StartGameOverlay
onready var options_overlay = $Overlay/OptionsOverlay

signal options_saved

func _ready():
	quit_confirm_menu.hide()
	start_game_overlay.hide()
	options_overlay.hide()

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		quit()

func play():
	if not Server.connected:
		return
	start_game_overlay.show()

func options():
	options_overlay.show()

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

func _on_OptionsMenu_options_saved():
	emit_signal("options_saved")
