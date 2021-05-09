extends Node2D

class_name Player

var is_active = false
var reinforcement = 10

signal turn_completed

func _ready():
	setup()

func setup():
	set_active(false)
	setup_reinforcements()

func setup_reinforcements():
	reinforcement = randi() % 10 + 3

func _input(event):
	if not is_active:
		return
	if event.is_action_pressed("move"):
		move()

func move():
	reinforcement -= 3
	if reinforcement < 0:
		reinforcement = 0
	set_active(false)
	emit_signal("turn_completed")

func set_active(value):
	is_active = value
	set_process_input(value)
	
