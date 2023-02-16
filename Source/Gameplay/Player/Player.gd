extends Node2D

class_name Player

var is_active = false
var reinforcement = 0
var countries_occupied = 0
var countries = []
var countries_occupied_in_continents = {
	"NorthAmerica": 0,
	"SouthAmerica": 0,
	"Europe": 0,
	"Africa": 0,
	"Asia": 0,
	"Australia": 0
}
var first_turn = true
var initial_troops = 9
var eliminated = false

onready var player_state = load("res://Source/Gameplay/StateMachine/PlayerStates/PlacementState.gd").new()
onready var hud: ActivePlayerHUD = find_node("ActivePlayerHUD")
onready var deploy_menu: DeployMenu = find_node("DeployMenu")
onready var attacking_menu: AttackingMenu = find_node("AttackingMenu")
onready var move_menu: MoveMenu = find_node("MoveMenu")
onready var gameover_menu: GameoverMenu = find_node("GameoverMenu")
onready var activities = find_node("Activities")
onready var overlay = find_node("Overlay")

var Activity = preload("res://Source/Gameplay/HUD/PlayerActivity.tscn")

signal turn_completed

func _ready():
	setup()

func setup():
	set_active(false)
	setup_reinforcements()
	setup_hud()
	setup_state()
	connect_signals()

func set_active(value):
	is_active = value
	if value:
		hud.show()
	else:
		hud.hide()
	set_process_input(value)

func setup_reinforcements(net_call=false):
	reinforcement = randi() % 10 + 3
	if net_call:
		return
	#Server.send_node_func_call(get_path(), "setup_reinforcements")

func setup_hud():
	var player_data
	if GamePlay.online:
		player_data = Server.my_lobby.players[int(name)]
	else:
		player_data = GamePlay.players_data[name]
	hud.set_player_name(player_data.name, int(name))
	hud.set_icon_color(player_data.color)
	hud.connect("go_pressed", self, "go_pressed")
	deploy_menu.hide()
	attacking_menu.hide()
	move_menu.hide()
	overlay.hide()
	gameover_menu.set_player_name(player_data.name)
	gameover_menu.hide()
	deploy_menu.connect("deployed", self, "troops_deployed")
	attacking_menu.connect("attacked", self, "player_attacked")
	move_menu.connect("moved", self, "troops_moved")

func setup_state():
	player_state.enter(self)

func connect_signals():
	connect("turn_completed", self, "turn_complete")

func set_activity(activity, net_call=false):
	var player_activity = Activity.instance()
	activities.add_child(player_activity)
	player_activity.set_activity(activity)
	if net_call:
		return
	#Server.send_node_func_call(get_path(), "set_activity", activity)

func occupy_country(country: Country, net_call = false):
	countries_occupied += 1
	countries.append(country)
	country.set_occupier(self)
	for continent in country.get_groups():
		if continent in GamePlay.total_countries_in_continents.keys():
			countries_occupied_in_continents[continent] += 1
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "occupy_country_by_path", country.get_path())
	Server.send_node_func_call(country.get_path(), "set_country_color")
	Server.send_node_func_call(country.get_path(), "set_border_color")

func occupy_country_by_path(country_path, net_call=false):
	if has_node(country_path):
		occupy_country(get_node(country_path), net_call)

func leave_country(country: Country, net_call=false):
	countries_occupied -= 1
	countries.erase(country)
	for continent in country.get_groups():
		if continent in GamePlay.total_countries_in_continents.keys():
			countries_occupied_in_continents[continent] -= 1
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "leave_country_by_path", country.get_path())

func leave_country_by_path(country_path, net_call=false):
	if has_node(country_path):
		leave_country(get_node(country_path), net_call)

func troops_moved(troops, source_country, destination_country):
	var state = player_state.troops_moved(self, troops, source_country, destination_country)
	if state:
		change_state(state)

func player_attacked(player_troop_count: int, opponent_troop_count: int, player_country: Country, opponent_country: Country):
	var state = player_state.player_attacked(self, player_troop_count, opponent_troop_count, player_country, opponent_country)
	if state:
		change_state(state)

func go_pressed():
	if GamePlay.online and Server.my_lobby.players[int(name)].id != Server.player_id:
		return
	if deploy_menu.visible or attacking_menu.visible or move_menu.visible or gameover_menu.visible:
		return
	var state = player_state.go_pressed(self)
	if state:
		change_state(state)

func troops_deployed(troops: int, country: Country):
	var state = player_state.troops_deployed(self, troops, country)
	if state:
		change_state(state)

func turn_complete(net_call=false):
	if player_state.get_class() == "Reinforce" and first_turn:
		return
	hud.hide()
	set_active(false)
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "turn_complete")

func set_initial_troops(amount, net_call=false):
	initial_troops = amount
	hud.set_reinforcement_label(initial_troops)
	if net_call:
		return
	#Server.send_node_func_call(get_path(), "set_initial_troops", amount)

func increment_initial_troops(net_call=false):
	initial_troops += 1
	hud.set_reinforcement_label(initial_troops)
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "increment_initial_troops")
	
func decrement_initial_troops(net_call=false):
	initial_troops -= 1
	hud.set_reinforcement_label(initial_troops)
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "decrement_initial_troops")

func set_reinforcement(amount = 0, net_call=false):
	reinforcement = amount
	hud.set_reinforcement_label(reinforcement)
	if net_call:
		return
	#Server.send_node_func_call(get_path(), "set_reinforcement", amount)

func increment_reinforcement(amount = 1, net_call=false):
	reinforcement += amount
	hud.set_reinforcement_label(reinforcement)
	if net_call:
		return
	#Server.send_node_func_call(get_path(), "increment_reinforcement", amount)

func decrement_reinforcement(amount = 1, net_call=false):
	reinforcement -= amount
	hud.set_reinforcement_label(reinforcement)
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "decrement_reinforcement", amount)

func all_troops_placed():
	var state = player_state.all_troops_placed(self)
	if state:
		change_state(state)

func change_state(state, net_call=false):
	print("Player ", name, " state changed.")
	var previous_state = player_state
	previous_state.exit(self)
	player_state = state
	print("Previous state: ", previous_state.get_class())
	print("New state: ", player_state.get_class())
	previous_state.queue_free()
	player_state.enter(self)
	if net_call:
		return
	state = state.get_state_name()
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "change_player_state", state)

func add_reinforcements(amount, net_call=false):
	reinforcement += amount
	if net_call:
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "add_reinforcements", amount)

func _input(event):
	if GamePlay.online:
		if Server.my_lobby.players[int(name)].id != Server.player_id:
			return
	if not is_active:
		return
	if event.is_action_pressed("move"):
		move()

func move():
	reinforcement -= 3
	if reinforcement < 0:
		reinforcement = 0
	set_active(false)
	emit_signal("turn_completed")

func country_clicked(country: Country):
	var state = player_state.country_clicked(self, country)
	if state:
		change_state(state)

func _process(delta):
	for country in countries:
		if not country.troops_label.visible:
			country.troops_label.visible = true
#	if Server.my_lobby.players[int(name)].id != Server.player_id:
#		return
	var state = player_state.update(self)
	if state:
		change_state(state)

func eliminate(net_call=false):
	eliminated = true
	if net_call:
		var player_name
		if GamePlay.online:
			player_name = Server.my_lobby.players[int(name)].name
		else:
			player_name = GamePlay.players_data[name].name
		set_activity(player_name + " has been eliminated!")
		return
	if not GamePlay.online: return
	Server.send_node_func_call(get_path(), "eliminate")

func change_player_state(state_name = "", net_call=false):
	var state = player_state.change_player_state(self, state_name)
	if state:
		change_state(state, net_call)

func game_over(net_call=false):
	gameover_menu.show()
	overlay.show()
