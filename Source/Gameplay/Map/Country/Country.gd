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
