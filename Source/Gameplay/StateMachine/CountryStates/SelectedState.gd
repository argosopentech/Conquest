extends CountryState

class_name SelectedState

func enter(country: Country):
	color_multiplier = 1.1
	.enter(country)

func handle_input(country: Country, input: InputEvent):
	return null

func update(country: Country):
	pass

func exit(country: Country):
	pass

func clicked(country: Country):
	return country_states.active.new()
