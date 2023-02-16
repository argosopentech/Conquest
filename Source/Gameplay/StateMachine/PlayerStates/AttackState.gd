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

func roll_six():
	return int(randf() * 6.0) + 1
	
func player_attacked(player: Player, player_troop_count: int, opponent_troop_count: int, player_country: Country, opponent_country: Country):
	randomize()
	player.overlay.hide()
	
	var successful = false
	var troops_lost = 0
	var opponent_troops_lost = 0
	
	var ROLL_SIZE = 3
	var playerRolls = []
	for i in range(ROLL_SIZE):
		if i < player_troop_count:
			playerRolls.append(roll_six())
		else:
			playerRolls.append(0)
	playerRolls.sort()
	print("playerRolls ", playerRolls)
	var opponentRolls = []
	for i in range(ROLL_SIZE):
		if i < opponent_troop_count:
			opponentRolls.append(roll_six())
		else:
			opponentRolls.append(0)
	opponentRolls.sort()
	print("opponentRolls ", opponentRolls)
	
	for i in range(ROLL_SIZE):
		var playerRoll = playerRolls[i]
		var opponentRoll = opponentRolls[i]
		
		if playerRoll == 0 or opponentRoll == 0:
			continue
		
		if playerRoll > opponentRoll:
			opponent_troops_lost += 1
		else:
			troops_lost += 1
	
	if opponent_troops_lost == opponent_troop_count:
		successful = true
	
	player_country.subtract_troops(troops_lost)
	opponent_country.subtract_troops(opponent_troops_lost)
	var activity
	if GamePlay.online:
		activity = Server.my_lobby.players[int(player.name)].name + " lost " + str(troops_lost) + " troops"
	else:
		activity = GamePlay.players_data[player.name].name + " lost " + str(troops_lost) + " troops"
	player.set_activity(activity)
	if GamePlay.online:
		activity = Server.my_lobby.players[int(player.name)].name + "'s attack on " + Server.my_lobby.players[int(opponent_country.occupier.name)].name + " failed."
	else:
		activity = GamePlay.players_data[player.name].name + "'s attack on " + GamePlay.players_data[opponent_country.occupier.name].name + " failed."
	if GamePlay.online:
		activity = Server.my_lobby.players[int(player.name)].name + "'s attack on " + Server.my_lobby.players[int(opponent_country.occupier.name)].name + " failed."
	if successful:
		if GamePlay.online:
			activity = Server.my_lobby.players[int(player.name)].name + "'s attack on " + Server.my_lobby.players[int(opponent_country.occupier.name)].name + " succeeded!."
		else:
			activity = GamePlay.players_data[player.name].name + "'s attack on " + GamePlay.players_data[opponent_country.occupier.name].name + " succeeded!."
#		if GamePlay.online:
#			activity = Server.my_lobby.players[int(player.name)].name + "'s attack on " + Server.my_lobby.players[int(opponent_country.occupier.name)].name + " succeeded!."
		if opponent_country.occupier.countries_occupied == 1:
			var elimination
			if GamePlay.online:
				elimination = Server.my_lobby.players[int(opponent_country.occupier.name)].name + " has been eliminated."
			else:
				elimination = GamePlay.players_data[opponent_country.occupier.name].name + " has been eliminated."
			player.set_activity(elimination)
			opponent_country.occupier.eliminate()
			if GamePlay.game.all_eliminated():
				player.overlay.show()
				player.gameover_menu.show()
				if GamePlay.online:
					Server.send_node_func_call(player.get_path(), "game_over")
		opponent_country.occupier.leave_country(opponent_country)
		player.occupy_country(opponent_country)
		opponent_country.set_troops(0)
		if GamePlay.online:
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
