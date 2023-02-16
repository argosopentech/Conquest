extends PlayerState

class_name DraftState

var bonus_troops = {
	"SouthAmerica": 2,
	"Australia": 2,
	"Africa": 3,
	"Europe": 5,
	"NorthAmerica": 5,
	"Asia": 7
}

func enter(player: Player):
	if player.eliminated:
		player.emit_signal("turn_completed")
		return
	.enter(player)
	player.set_reinforcement()
	add_reinforcement_amount(player)
	player.hud.set_player_state(get_class())
	player.hud.hide_go_button()
	player.hud.show_draft_icon()

func add_reinforcement_amount(player: Player):
	var default = int(player.countries_occupied / 3)
	if default < 3:
		default = 3
	var activity = ""
	if GamePlay.online:
		activity = Server.my_lobby.players[int(player.name)].name + " gets " + str(default) + " troops for occupying " + str(player.countries_occupied) + " countries."
	else:
		activity = GamePlay.players_data[player.name].name + " gets " + str(default) + " troops for occupying " + str(player.countries_occupied) + " countries."
	print(activity)
	player.set_activity(activity)
	player.increment_reinforcement(default)
	add_continental_bonus(player)
	add_first_turn_bonus(player)

func add_continental_bonus(player: Player):
	for continent in bonus_troops.keys():
		if player.countries_occupied_in_continents[continent] == GamePlay.total_countries_in_continents[continent]:
			var activity
			if GamePlay.online:
				activity = Server.my_lobby.players[int(player.name)].name + " gets " + str(bonus_troops[continent]) + " for occupying " + continent
			else:
				activity = GamePlay.players_data[player.name].name + " gets " + str(bonus_troops[continent]) + " for occupying " + continent
			print(activity)
			player.set_activity(activity)
			player.increment_reinforcement(bonus_troops[continent])

func add_first_turn_bonus(player: Player):
	if player.first_turn:
		var player_name = int(player.name) + 1
		if player_name > 3:
			var turn_bonus = player_name % 3
			var activity
			if GamePlay.online:
				activity = Server.my_lobby.players[int(player.name)].name + " gets " + str(turn_bonus) + " for being at " + str(player_name) + " position"
			else:
				activity = GamePlay.players[player.name].name + " gets " + str(turn_bonus) + " for being at " + str(player_name) + " position"
			print(activity)
			player.set_activity(activity)
			player.increment_reinforcement(turn_bonus)
		player.first_turn = false

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	if player.reinforcement:
		player.overlay.show()
		player.deploy_menu.show()
		player.deploy_menu.add_troops(player.reinforcement, country)

func troops_deployed(player: Player, troops: int, country: Country):
	player.decrement_reinforcement(troops)
	country.add_troops(troops)
	player.overlay.hide()
	if player.reinforcement == 0:
		player.hud.hide_draft_icon()
		player.hud.show_go_button()

func go_pressed(player: Player):
	return player_states.attack.new()

func get_class():
	return "Reinforce"

func change_player_state(player: Player, state_name = ""):
	if state_name == "attack":
		return player_states.attack.new()
	if state_name == "fortify":
		return player_states.fortify.new()
	if state_name == "placement":
		return player_states.placement.new()

func get_state_name():
	return "draft"
