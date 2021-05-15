extends CountryState

class_name InActiveState

func enter(country: Country):
	country.active = false
	color_multiplier = 0.9
	.enter(country)

func handle_input(country: Country, input: InputEvent):
	return null

func update(country: Country):
	if Input.is_action_just_pressed("ui_accept"):
		return country_states.active.new()

func exit(country: Country):
	set_border_color(country)
