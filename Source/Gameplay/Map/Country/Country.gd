extends Area2D

class_name Country

onready var sprite = $Country
onready var border = $Border

var occupier = null
var hovering = false
var selected = false
var active = false
var troops = 0

onready var country_state = load("res://Source/Gameplay/StateMachine/CountryStates/ActiveState.gd").new()
onready var name_label = $Name
onready var troops_label = $Troops

func _ready():
	setup()

func setup():
	name_label.text = get_name()
	setup_state()

func setup_state():
	country_state.enter(self)

func _process(delta):
	var state = country_state.update(self)
	if state:
		change_state(state)

func update():
	var state = country_state.update(self)
	if state:
		change_state(state)

func change_state(state):
	var previous_state = country_state
	previous_state.exit(self)
	country_state = state
	country_state.enter(self)
	previous_state.queue_free()

func get_name():
	return space_pascal_case(name)

func space_pascal_case(string):
	var index = 0
	var new_string = ""
	for letter in string:
		if index == 0:
			new_string += letter
		else:
			if letter.to_upper() == letter:
				new_string = new_string + " " + letter
			else:
				new_string += letter
		index += 1
	return new_string

func _on_mouse_entered():
	hovering = true

func _on_mouse_exited():
	hovering = false

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				var state = country_state.clicked(self)
				if state:
					change_state(state)

func _input(event):
	if event.is_action_pressed("reveal_country_names"):
		name_label.visible = !name_label.visible
