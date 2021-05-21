extends PlayerState

class_name PlacementState

func enter(player: Player):
	.enter(player)

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	if not country.occupier or (country.occupier == player and GamePlay.game.occupied_countries == GamePlay.game.total_countries):
		if not country.occupier:
			country.occupier = player
			GamePlay.game.occupied_countries += 1
			player.countries_occupied += 1
			player.countries.append(country)
			player.countries_occupied_in_continents[country.get_groups()[2]] += 1
		country.increment_troops()
		player.initial_troops -= 1
		country.update()
		player.emit_signal("turn_completed")

func get_class():
	return "Placement State"

func all_troops_placed(player: Player):
	return player_states.draft.new()
