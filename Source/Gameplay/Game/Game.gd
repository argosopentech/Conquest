extends Node2D

class_name Game

onready var countries = find_node("Countries")
onready var players = find_node("PlayersQueue")

var active_player: Player = null
var active_player_index = -1
var occupied_countries = 0
var total_countries = 42
var number_of_players_placed_all_troops = 0
var auto_place = true

func _ready():
	setup()

func setup():
	GamePlay.game = self
	set_initial_troops()

func number_of_players():
	return players.get_child_count()

func set_initial_troops():
	var subtraction = 5 * (number_of_players() - 1)
	var initial_troops = 45 - subtraction
	for player in players.get_children():
		player.set_initial_troops(initial_troops)

func active_player_changed(p_active_index, p_active_player: Player):
	yield(get_tree(), "idle_frame")
	active_player = p_active_player
	active_player_index = p_active_index
	update_countries_on_turn_complete()
	if all_players_placed_all_troops():
		p_active_player.all_troops_placed()
	else:
		if auto_place:
			auto_place_troops()

func auto_place_troops():
	var placed = false
	while (not placed):
		var i = randi() % 42
		var country: Country = countries.get_child(i)
		var troops_before = country.troops
		country.country_clicked()
		if troops_before < country.troops:
			placed = true

func _input(event):
	if event.is_action_pressed("quit"):
		quit()

func quit():
	get_tree().change_scene("res://Source/Main/Main.tscn")

func update_countries_on_turn_complete():
	for country in countries.get_children():
		country.active_player_changed(active_player)

func all_countries_occupied():
	if occupied_countries == total_countries:
		return true
	return false

func no_country_occupied():
	if occupied_countries == 0:
		return true
	return false

func all_players_placed_all_troops():
	for player in players.get_children():
		if player.initial_troops > 0:
			return false
	return true
