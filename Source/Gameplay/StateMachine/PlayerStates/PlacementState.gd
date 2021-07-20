extends PlayerState

class_name PlacementState

func enter(player: Player):
	.enter(player)
	player.hud.set_player_state(get_class())
	player.hud.hide_go_button()
	player.hud.show_draft_icon()

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	if not country.occupier or (country.occupier == player and GamePlay.game.occupied_countries == GamePlay.game.total_countries):
		if not country.occupier:
			country.set_occupier(player)
			GamePlay.game.increment_occupied_countries()
			player.occupy_country(country)
		country.increment_troops()
		player.decrement_initial_troops()
		country.update()
		player.emit_signal("turn_completed")

func get_class():
	return "Claim"

func all_troops_placed(player: Player):
	return player_states.draft.new()

func change_player_state(player: Player, state_name = ""):
	if state_name == "draft":
		return player_states.draft.new()
	if state_name == "fortify":
		return player_states.fortify.new()
	if state_name == "attack":
		return player_states.attack.new()

func get_state_name():
	return "placement"
