
extends PlayerState

class_name FortifyState

var selected_country: Country = null

func enter(player: Player):
	.enter(player)
	player.hud.set_player_state(get_class())
	push_countries_in_fortify_state(player)

func push_countries_in_fortify_state(player: Player):
	for country in player.countries:
		country.change_country_state("active")
		if country.troops == 1:
			country.change_country_state("in_active")
			continue
		var has_alliance_nearyby = false
		for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
			if bordering_country.occupier == player:
				has_alliance_nearyby = true
				break
		if not has_alliance_nearyby:
			country.change_country_state("in_active")

func handle_input(player: Player, input: InputEvent):
	return null

func update(player: Player):
	pass

func exit(player: Player):
	.exit(player)

func country_clicked(player: Player, country: Country):
	if selected_country:
		if selected_country.name == country.name:
			unselect_country(player, country)
		else:
			player.move_menu.move_troops(selected_country, country, "Fortify")
			player.move_menu.show()
			player.overlay.show()
	else:
		select_country(player, country)

func select_country(player: Player, country: Country):
	for player_country in player.countries:
		player_country.change_country_state("in_active")
	activate_bordering_countries(country)
	country.change_country_state("selected")
	selected_country = country

func activate_bordering_countries(country: Country):
	for bordering_country in GamePlay.bordering_countries_nodes[country.name]:
		if bordering_country.occupier == country.occupier:
			if not bordering_country.country_state.get_class() in ["Selected State", "Active State"]:
				bordering_country.change_country_state("active")
				activate_bordering_countries(bordering_country)

func unselect_country(player: Player, country: Country):
	push_countries_in_fortify_state(player)
	selected_country = null

func get_class():
	return "Fortify"

func go_pressed(player: Player):
	player.emit_signal("turn_completed")

func all_troops_placed(player: Player):
	return player_states.draft.new()

func troops_moved(player: Player, troops: int, source_country: Country, destination_country: Country):
	destination_country.add_troops(troops)
	source_country.subtract_troops(troops)
	unselect_country(player, source_country)
	player.emit_signal("turn_completed")
	player.overlay.hide()

func change_player_state(player: Player, state_name = ""):
	if state_name == "draft":
		return player_states.draft.new()
	if state_name == "attack":
		return player_states.attack.new()
	if state_name == "placement":
		return player_states.placement.new()

func get_state_name():
	return "fortify"
