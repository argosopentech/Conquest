extends HBoxContainer

class_name ActivePlayerHUD

onready var icon = $IconBorder/Icon
onready var name_label = $InfoBorder/Info/Name
onready var state_label = $InfoBorder/Info/State
onready var reinforcement_label = $DraftIcon/Reinforcements
onready var draft_icon = $DraftIcon
onready var go_button = $GoButton

signal go_pressed

func set_icon_color(color):
	icon.color = color

func set_player_name(player_name):
	name_label.text = "Player " + player_name

func set_player_state(state):
	state_label.text = state

func set_reinforcement_label(reinforcement):
	reinforcement_label.text = str(reinforcement)

func hide_draft_icon():
	draft_icon.hide()

func show_draft_icon():
	draft_icon.show()

func hide_go_button():
	go_button.hide()

func show_go_button():
	go_button.show()

func go_pressed():
	emit_signal("go_pressed")
