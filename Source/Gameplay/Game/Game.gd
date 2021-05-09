extends Node2D

class_name Game

onready var hud = find_node("HUD")

func active_player_changed(active_index, active_player):
	if not hud:
		yield(self, "ready")
	hud.update_display(active_index, active_player)

func _input(event):
	if event.is_action_pressed("quit"):
		quit()

func quit():
	get_tree().change_scene("res://Source/Main/Main.tscn")
