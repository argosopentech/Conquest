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
	if GamePlay.game.active_player.player_state is AttackState:
		for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
			if bordering_country.occupier != country.occupier:
				bordering_country.change_country_state("in_active")
		return country_states.active.new()
	elif GamePlay.game.active_player.player_state is FortifyState:
		GamePlay.game.active_player.country_clicked(country)

func get_class():
	return "Selected State"

func change_country_state(country: Country, state_name = ""):
	if state_name == "in_active":
		return country_states.in_active.new()
	if state_name == "active":
		return country_states.active.new()
