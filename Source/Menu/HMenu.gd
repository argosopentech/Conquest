extends HBoxContainer

class_name HMenu

var index = 0

func _ready():
	setup()

func setup():
	index = 0
	connect_child_signals()
	grab_focus_on_index_child()

func connect_child_signals():
	var i = 0
	for child in get_children():
		var is_a_button = child is Button or child is TextureButton or child is SmartButton
		if child.has_signal("focus_entered") and is_a_button:
			child.connect("focus_entered", self, "move_index_on_focused_child", [i])
		i += 1

func move_index_on_focused_child(new_index):
	index = new_index

func grab_focus_on_index_child():
	if get_child_count() > index and index >= 0:
		var child = get_child(index)
		var is_a_button = child is Button or child is TextureButton or child is SmartButton
		if child.has_method("grab_focus") and is_a_button:
				child.grab_focus()
		else:
			next()

func next():
	index += 1
	if index >= get_child_count():
		index = 0
	var child = get_child(index)
	var is_a_button = child is Button or child is TextureButton or child is SmartButton
	if child.has_method("grab_focus") and is_a_button:
		grab_focus_on_index_child()
	else:
		next()

func previous():
	index -= 1
	if index < 0:
		index = get_child_count() - 1
	var child = get_child(index)
	var is_a_button = child is Button or child is TextureButton or child is SmartButton
	if child.has_method("grab_focus") and is_a_button:
		grab_focus_on_index_child()
	else:
		previous()

func _unhandled_input(event):
	if event.is_action_pressed("previous"):
		previous()
	if event.is_action_pressed("next"):
		next()
