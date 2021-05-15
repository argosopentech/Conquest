extends Node2D

class_name Game

onready var hud = find_node("HUD")

var active_player = null
var active_player_index = -1

func active_player_changed(p_active_index, p_active_player):
	if not hud:
		yield(self, "ready")
	active_player = p_active_player
	active_player_index = p_active_index
	hud.update_display(active_player_index, active_player)

func _input(event):
	if event.is_action_pressed("quit"):
		quit()

func quit():
	get_tree().change_scene("res://Source/Main/Main.tscn")
