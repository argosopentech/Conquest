extends StateMachine

class_name CountryState

var colors = {
	"unoccupied": Color.burlywood,
	"hover": Color.white,
	"not_hover": Color.black
}

var country_states = {
	"in_active": load("res://Source/Gameplay/StateMachine/CountryStates/InActiveState.gd"),
	"active": load("res://Source/Gameplay/StateMachine/CountryStates/ActiveState.gd"),
	"selected": load("res://Source/Gameplay/StateMachine/CountryStates/SelectedState.gd"),
}

var color_multiplier = 1
var hover_multiplier = 1.25

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
		country.sprite.modulate = GamePlay.colors[country.occupier.name]
	else:
		country.sprite.modulate = colors.unoccupied

func set_border_color(country: Country):
	if not country.active:
		country.border.modulate = colors.not_hover
		return
	if country.hovering or country.selected:
		country.border.modulate = colors.hover
		dim_border_color(country)
	else:
		country.border.modulate = colors.not_hover

func dim_border_color(country: Country):
	country.border.modulate.r *= hover_multiplier
	country.border.modulate.g *= hover_multiplier
	country.border.modulate.b *= hover_multiplier

func dim_country_color(country: Country):
	country.sprite.modulate.r *= color_multiplier
	country.sprite.modulate.g *= color_multiplier
	country.sprite.modulate.b *= color_multiplier
