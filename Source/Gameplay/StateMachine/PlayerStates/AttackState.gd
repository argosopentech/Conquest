extends PlayerState

class_name AttackState

var selected_country: Country = null

func enter(player: Player):
	.enter(player)
	player.hud.set_player_state(get_class())
	for country in player.countries:
		country.active_player_changed(player)

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	if not selected_country:
		selected_country = country

func get_class():
	return "Attack"

func go_pressed(player: Player):
	return player_states.fortify.new()
