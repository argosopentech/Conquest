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
		country.increment_troops()
		player.initial_troops -= 1
		country.update()
		if GamePlay.game.all_players_placed_all_troops():
			return player_states.draft.new()
		player.emit_signal("turn_completed")

func get_class():
	return "Placement State"

func all_troops_placed(player: Player):
	return player_states.draft.new()
