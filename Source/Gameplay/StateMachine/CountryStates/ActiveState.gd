extends CountryState

class_name ActiveState

func enter(country: Country):
	country.active = true
	color_multiplier = 1
	.enter(country)

func handle_input(country: Country, input: InputEvent):
	return null

func update(country: Country):
	set_country_color(country)
	set_border_color(country)
	if Input.is_action_just_pressed("ui_accept"):
		return country_states.in_active.new()

func exit(country: Country):
	set_border_color(country)

func clicked(country: Country):
	GamePlay.game.active_player.country_clicked(country)
	return# country_states.selected.new()
