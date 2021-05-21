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
	.enter(player)
	player.set_reinforcement()
	add_reinforcement_amount(player)
	player.hud.set_player_state(get_class())

func add_reinforcement_amount(player: Player):
	var default = int(player.countries_occupied / 3)
	if default < 3:
		default = 3
	var activity = "Player " + player.name + " gets " + str(default) + " troops for occupying " + str(player.countries_occupied) + " countries."
	print(activity)
	player.set_activity(activity)
	player.increment_reinforcement(default)
	add_continental_bonus(player)
	add_first_turn_bonus(player)

func add_continental_bonus(player: Player):
	for continent in bonus_troops.keys():
		if player.countries_occupied_in_continents[continent] == GamePlay.total_countries_in_continents[continent]:
			var activity = "Player gets " + str(bonus_troops[continent]) + " for occupying " + continent
			print(activity)
			player.set_activity(activity)
			player.increment_reinforcement(bonus_troops[continent])

func add_first_turn_bonus(player: Player):
	if player.first_turn:
		var player_name = int(player.name)
		if player_name > 3:
			var turn_bonus = player_name % 3
			var activity = "Player " + player_name + " gets " + str(turn_bonus) + " for being at " + player_name + " position"
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
	pass

func get_class():
	return "Reinforce"
