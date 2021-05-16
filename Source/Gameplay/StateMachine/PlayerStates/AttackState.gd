extends PlayerState

class_name AttackState

func enter(player: Player):
	pass

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	pass

func country_clicked(player: Player, country: Country):
	pass
