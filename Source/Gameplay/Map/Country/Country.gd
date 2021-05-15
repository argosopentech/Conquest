extends Area2D

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
	pass

func _on_mouse_exited():
	pass # Replace with function body.

func _on_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
