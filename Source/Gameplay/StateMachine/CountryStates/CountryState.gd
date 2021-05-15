extends StateMachine

class_name CountryState

var colors = {
	"unoccupied": Color.lightblue,
	"hover": Color.white,
	"not_hover": Color.black
}

var country_states = {
	"in_active": load("res://Source/Gameplay/StateMachine/CountryStates/InActiveState.gd"),
	"active": load("res://Source/Gameplay/StateMachine/CountryStates/ActiveState.gd"),
	"selected": load("res://Source/Gameplay/StateMachine/CountryStates/SelectedState.gd"),
}

var color_multiplier = 1

func enter(country: Country):
	set_country_color(country)
	dim_country_color(country)
	set_border_color(country)

func handle_input(country: Country, input: InputEvent):
	return null

func update(country: Country):
	pass

func exit(country: Country):
	pass

func clicked(country: Country):
	pass

func set_country_color(country: Country):
	if country.occupier:
		country.sprite.color = GamePlay.colors[country.occupier.name]
	else:
		country.sprite.color = colors.unoccupied

func set_border_color(country: Country):
	if not country.active:
		country.border.color = colors.not_hover
		return
	if country.hovering or country.selected:
		country.border.color = colors.hover
	else:
		country.border.color = colors.not_hover

func dim_country_color(country: Country):
	country.sprite.color.r *= color_multiplier
	country.sprite.color.g *= color_multiplier
	country.sprite.color.b *= color_multiplier
