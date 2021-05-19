extends PlayerState

class_name FortifyState

func enter(player: Player):
	.enter(player)

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	pass

func get_class():
	return "Fortify State"
