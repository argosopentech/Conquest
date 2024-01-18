class_name Main extends Control

@onready var buttons: VBoxContainer = $MarginContainer/Menu/Headers/Buttons
@onready var windows: MarginContainer = $MarginContainer/Menu/Windows/MarginContainer

var button_pressed: StringName = &"Play"

func _ready():
	connect_signals()

func connect_signals():
	for button: Button in buttons.get_children():
		button.pressed.connect(_on_button_pressed.bind(button.name))

func _on_button_pressed(button_name: StringName):
	var window_path = str(button_pressed) + "Window"
	windows.get_node(window_path).hide()
	button_pressed = button_name
	window_path = str(button_pressed) + "Window"
	windows.get_node(window_path).show()
