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

func country_clicked(player: Player, country: Country):
	pass

func get_class():
	return "Attack"
