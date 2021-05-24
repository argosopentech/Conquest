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
	if selected_country:
		if country.occupier == player:
			unselect_country(selected_country)
			select_country(country)
		else:
			player.attacking_menu.attack_details(selected_country, country)
			player.attacking_menu.show()
	else:
		select_country(country)

func player_attacked(player: Player, troops: int, player_country: Country, opponent_country: Country):
	print("Attack Complete!")
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
