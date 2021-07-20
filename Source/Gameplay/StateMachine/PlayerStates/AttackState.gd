extends PlayerState

class_name AttackState

var selected_country: Country = null

func enter(player: Player):
	.enter(player)
	player.hud.set_player_state(get_class())
	push_countries_in_attack_state(player)

func push_countries_in_attack_state(player: Player):
	for country in player.countries:
		if country.troops == 1:
			country.change_country_state("in_active")
			continue
		var has_enemy = false
		for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
			if bordering_country.occupier != player:
				has_enemy = true
				break
		if not has_enemy:
			country.change_country_state("in_active")

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	if selected_country:
		if selected_country.troops == 1:
			selected_country.change_country_state("in_active")
			yield(get_tree(), "idle_frame")
			selected_country = null


func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	if selected_country:
		if country.occupier == player:
			unselect_country(selected_country)
			select_country(country)
		else:
			player.attacking_menu.attack_details(selected_country, country)
			player.attacking_menu.show()
			player.overlay.show()
	else:
		select_country(country)

func player_attacked(player: Player, win_chance_percentage, troops: int, player_country: Country, opponent_country: Country):
	randomize()
	player.overlay.hide()
	var random_number = randi() % 4
	var successful = false
	var troops_lost = 1
	if troops - 1 > 1:
		troops_lost = randi() % (troops - 1) + 1
	if win_chance_percentage > 90:
		troops_lost = randi() % 3 + 1
		successful = true
	elif win_chance_percentage > 75:
		if troops - 5 > 1:
			troops_lost = randi() % (troops - 4) + 1
		else:
			troops_lost = 1
		if random_number > 0:
			successful = true
	elif win_chance_percentage > 50:
		if troops - 3 > 1:
			troops_lost = randi() % (troops - 3) + 1
		if random_number > 1:
			successful = true
	elif win_chance_percentage > 25:
		if troops - 2 > 1:
			troops_lost = randi() % (troops - 2) + 1
		if random_number > 2:
			successful = true
	if troops <= 3:
		troops_lost = 1
	if random_number > win_chance_percentage:
		successful = true
	player_country.subtract_troops(troops_lost)
	var activity = Server.my_lobby.players[int(player.name)].name + " lost " + str(troops_lost) + " troops"
	player.set_activity(activity)
	activity = Server.my_lobby.players[int(player.name)].name + "'s attack on " + Server.my_lobby.players[int(opponent_country.occupier.name)].name + " failed."
	if successful:
		activity = Server.my_lobby.players[int(player.name)].name + "'s attack on " + Server.my_lobby.players[int(opponent_country.occupier.name)].name + " succeeded!."
		if opponent_country.occupier.countries_occupied == 1:
			var elimination = Server.my_lobby.players[int(opponent_country.occupier.name)].name + " has been eliminated."
			player.set_activity(elimination)
			opponent_country.occupier.eliminate()
			if GamePlay.game.all_eliminated():
				player.overlay.show()
				player.gameover_menu.show()
				Server.send_node_func_call(player.get_path(), "game_over")
		opponent_country.occupier.leave_country(opponent_country)
		player.occupy_country(opponent_country)
		opponent_country.set_troops(0)
		Server.send_node_func_call(opponent_country.get_path(), "set_country_color")
		Server.send_node_func_call(opponent_country.get_path(), "set_border_color")
		if not GamePlay.game.all_eliminated():
			player.move_menu.show()
			player.move_menu.move_troops(player_country, opponent_country, "Attack")
			player.overlay.show()
		if player_country.troops == 1:
			player_country.change_country_state("in_active")
	else:
		if player_country.troops == 1:
			player_country.change_country_state("in_active")
	player.set_activity(activity)
	unselect_country(player_country)

func select_country(country: Country):
	for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
		if bordering_country.occupier != country.occupier:
			bordering_country.change_country_state("active")
	country.change_country_state("selected")
	selected_country = country

func unselect_country(country: Country):
	for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
		if bordering_country.occupier != country.occupier:
			bordering_country.change_country_state("in_active")
	country.change_country_state("active")
	selected_country = null

func get_class():
	return "Attack"

func go_pressed(player: Player):
	return player_states.fortify.new()

func troops_moved(player: Player, troops: int, source_country: Country, destination_country: Country):
	destination_country.add_troops(troops)
	source_country.subtract_troops(troops)
	if source_country.troops == 1:
		source_country.change_country_state("in_active")
	player.overlay.hide()

func change_player_state(player: Player, state_name = ""):
	if state_name == "draft":
		return player_states.draft.new()
	if state_name == "fortify":
		return player_states.fortify.new()
	if state_name == "placement":
		return player_states.placement.new()

func get_state_name():
	return "attack"
