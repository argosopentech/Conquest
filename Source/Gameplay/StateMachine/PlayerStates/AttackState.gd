extends PlayerState

class_name AttackState

func enter(player: Player):
	.enter(player)
	player.hud.set_player_state(get_class())

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

var state

func country_clicked(player: Player, country: Country):
	return
	state = country.country_state.country_states.selected
	print("New Country State: ", state.get_class())
	country.change_state(state)

func get_class():
	return "Attack"

func go_pressed(player: Player):
	return player_states.fortify.new()
