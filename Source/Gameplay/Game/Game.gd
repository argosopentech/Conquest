extends Node2D

class_name Game

onready var hud = find_node("HUD")
onready var countries = find_node("Countries")
onready var players = find_node("PlayersQueue")

var active_player = null
var active_player_index = -1
var occupied_countries = 0
var total_countries = 42
var number_of_players_placed_all_troops = 0

func _ready():
	GamePlay.game = self

func active_player_changed(p_active_index, p_active_player):
	if not hud:
		yield(self, "ready")
	active_player = p_active_player
	active_player_index = p_active_index
	hud.update_display(active_player_index, active_player)
	update_countries_on_turn_complete()

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
