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
			for continent in country.get_groups():
				if continent in GamePlay.total_countries_in_continents.keys():
					player.countries_occupied_in_continents[continent] += 1
		country.increment_troops()
		player.initial_troops -= 1
		country.update()
		player.emit_signal("turn_completed")

func get_class():
	return "Claim"

func all_troops_placed(player: Player):
	return player_states.draft.new()
