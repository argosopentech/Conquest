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

func active_player_changed(country: Country, new_player: Player):
	if new_player.player_state is PlacementState or new_player.player_state is FortifyState:
		if country.occupier == new_player and GamePlay.game.all_countries_occupied():
			return country_states.active.new()

func get_class():
	return "In-Active State"
