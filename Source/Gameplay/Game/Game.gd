extends Node2D

class_name Game

var player_scene = preload("res://Source/Gameplay/Player/Player.tscn")

onready var countries = find_node("Countries")
onready var players: PlayersQueue = find_node("PlayersQueue")
onready var auto_place_button = find_node("AutoPlaceBorder")
onready var overlay = find_node("Overlay")
onready var quit_game_menu = find_node("QuitGameMenu")
onready var quit_pressed_audio = $HUD/QuitBorder/QuitButton/Pressed
onready var options_pressed_audio = $HUD/OptionsBorder/OptionsButton/Pressed
onready var options_overlay = find_node("OptionsOverlay")

var active_player: Player = null
var active_player_index = -1
var occupied_countries = 0
var total_countries = 42
var number_of_players_placed_all_troops = 0
var auto_place = false

func _ready():
	setup()

func setup():
	spawn_players()
	set_initial_troops()
	setup_hud()
	setup_music()
	setup_game()
	connect_signals()

func spawn_players():
	var current_players = GamePlay.number_of_players
	if GamePlay.online:
		current_players = Server.my_lobby.players 
	for i in current_players:
		var p = player_scene.instance()
		p.name = str(i)
		players.add_child(p)
	players.setup()

func set_initial_troops():
	var current_players = GamePlay.number_of_players
	if GamePlay.online:
		current_players = Server.my_lobby.current_players 
	var subtraction = 5 * (current_players - 1)
	var initial_troops = 45 - subtraction
	for player in players.get_children():
		player.set_initial_troops(initial_troops)

func setup_hud():
	overlay.hide()
	quit_game_menu.hide()

func setup_music():
	GamePlay.set_music_volume(GamePlay.in_game_volume)

func setup_game():
	GamePlay.game = self

func connect_signals():
	if GamePlay.online:
		Server.connect("lobby_updated_signal", self, "back_to_lobby")

func back_to_lobby(lobby_data, reason):
	Server.lobby_data = lobby_data
	Server.reason = reason
	get_tree().change_scene("res://Source/Gameplay/HUD/Lobby.tscn")

func number_of_players():
	return players.get_child_count()

func active_player_changed(p_active_index, p_active_player: Player):
	active_player = p_active_player
	active_player_index = p_active_index
	update_countries_on_turn_complete()
	if all_players_placed_all_troops():
		p_active_player.all_troops_placed()
		auto_place_button.hide()
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

func auto_place_turned_on():
	auto_place_button.hide()
	auto_place = true
	auto_place_troops()

func _input(event):
	if event.is_action_pressed("quit"):
		quit()

func quit():
	if GamePlay.interface_sound:
		quit_pressed_audio.play()
	quit_game_menu.show()
	overlay.show()

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

func all_eliminated():
	var eliminations = 0
	for player in players.get_children():
		if player.eliminated:
			eliminations += 1
	if eliminations == players.get_child_count() - 1:
		return true

func options_saved():
	setup_music()

func options():
	if GamePlay.interface_sound:
		options_pressed_audio.play()
	options_overlay.show()

func increment_occupied_countries(net_call=false):
	occupied_countries += 1
	if net_call:
		return
	if GamePlay.online:
		Server.send_node_func_call(get_path(), "increment_occupied_countries")
