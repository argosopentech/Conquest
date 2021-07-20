extends CountryState

class_name InActiveState

func enter(country: Country):
	country.active = false
	color_multiplier = 0.7
	.enter(country)

func handle_input(country: Country, input: InputEvent):
	return null

func update(country: Country):
	pass
#	if Input.is_action_just_pressed("ui_accept"):
#		return country_states.active.new()

func exit(country: Country):
	set_border_color(country)

func active_player_changed(country: Country, new_player: Player):
	if new_player.player_state is PlacementState or new_player.player_state is FortifyState:
		if country.occupier == new_player and GamePlay.game.all_countries_occupied():
			return country_states.active.new()
	if new_player.player_state is AttackState:
		if country.occupier == new_player and country.troops > 1:
			var has_enemy = false
			for country in GamePlay.bordering_countries[country.name]:
				if country.occupier != new_player:
					has_enemy = true
			if has_enemy:
				return country_states.active.new()

func get_class():
	return "In-Active State"

func get_state_name():
	return "in_active"

func change_country_state(country: Country, state_name = ""):
	if state_name == "selected":
		return country_states.selected.new()
	if state_name == "active":
		return country_states.active.new()

func set_country_color(country: Country):
	.set_country_color(country)

func set_border_color(country: Country):
	.set_border_color(country)
