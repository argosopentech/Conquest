extends Node2D

class_name Player

var is_active = false
var reinforcement = 10
var initial_troops = 20

onready var player_state = load("res://Source/Gameplay/StateMachine/PlayerStates/PlacementState.gd").new()

signal turn_completed

func _ready():
	setup()

func setup():
	set_active(false)
	setup_reinforcements()
	setup_state()

func setup_state():
	player_state.enter(self)

func change_state(state):
	var previous_state = player_state
	previous_state.exit(self)
	player_state = state
	player_state.enter(self)
	previous_state.queue_free()
	print("Player: ", name, " state changed.")
	print("New state: ", player_state.get_class())

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

func country_clicked(country: Country):
	var state = player_state.country_clicked(self, country)
	if state:
		change_state(state)

func _process(delta):
	var state = player_state.update(self)
	if state:
		change_state(state)
