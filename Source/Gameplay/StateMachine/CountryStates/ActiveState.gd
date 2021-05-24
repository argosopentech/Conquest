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
#	if country.occupier == GamePlay.game.active_player:
#		if GamePlay.game.active_player.player_state.get_class() == "Attack":
#			for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
#				if bordering_country.occupier != country.occupier:
#					bordering_country.change_country_state("active")
#			return country_states.selected.new()

func active_player_changed(country: Country, new_player: Player):
	if new_player.player_state is PlacementState or new_player.player_state is FortifyState:
		if country.occupier and country.occupier != new_player:
			return country_states.in_active.new()
	if new_player.player_state is AttackState:
		if country.occupier != new_player:
			return country_states.in_active.new()
		if country.troops == 1:
			return country_states.in_active.new()
		var has_enemy = false
		if country:
			for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
				if bordering_country.occupier != new_player:
					has_enemy = true
			if not has_enemy:
				return country_states.in_active.new()

func get_class():
	return "Active State"

func change_country_state(country: Country, state_name = ""):
	if state_name == "selected":
		return country_states.selected.new()
	if state_name == "in_active":
		return country_states.in_active.new()
