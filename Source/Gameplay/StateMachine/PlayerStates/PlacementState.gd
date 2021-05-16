extends PlayerState

class_name PlacementState

func enter(player: Player):
	pass

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	pass

func country_clicked(player: Player, country: Country):
	if not country.occupier:
		country.occupier = player
		GamePlay.game.occupied_countries += 1
	country.troops += 1
	country.update()
	player.emit_signal("turn_completed")
	if GamePlay.game.occupied_countries == GamePlay.game.total_countries:
		return player_states.draft.new()
