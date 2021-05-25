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
	connect("turn_completed", self, "turn_complete")
	setup_state()

func set_activity(activity):
	var player_activity = Activity.instance()
	activities.add_child(player_activity)
	player_activity.set_activity(activity)

func occupy_country(country: Country):
	countries_occupied += 1
	countries.append(country)
	country.occupier = self
	for continent in country.get_groups():
		if continent in GamePlay.total_countries_in_continents.keys():
			countries_occupied_in_continents[continent] += 1

func leave_country(country: Country):
	countries_occupied -= 1
	countries.erase(country)
	for continent in country.get_groups():
		if continent in GamePlay.total_countries_in_continents.keys():
			countries_occupied_in_continents[continent] -= 1

func setup_hud():
	hud.set_player_name(name)
	hud.set_icon_color(GamePlay.colors[name])
	hud.connect("go_pressed", self, "go_pressed")
	deploy_menu.hide()
	attacking_menu.hide()
	move_menu.hide()
	overlay.hide()
	gameover_menu.set_player_name(name)
	gameover_menu.hide()
	deploy_menu.connect("deployed", self, "troops_deployed")
	attacking_menu.connect("attacked", self, "player_attacked")
	move_menu.connect("moved", self, "troops_moved")

func troops_moved(troops, source_country, destination_country):
	var state = player_state.troops_moved(self, troops, source_country, destination_country)
	if state:
		change_state(state)

func player_attacked(win_chance_percentage, troops: int, player_country: Country, opponent_country: Country):
	var state = player_state.player_attacked(self, win_chance_percentage, troops, player_country, opponent_country)
	if state:
		change_state(state)

func go_pressed():
	var state = player_state.go_pressed(self)
	if state:
		change_state(state)

func troops_deployed(troops: int, country: Country):
	var state = player_state.troops_deployed(self, troops, country)
	if state:
		change_state(state)

func turn_complete():
	if player_state.get_class() == "Reinforce" and first_turn:
		return
	hud.hide()
	set_active(false)

func set_initial_troops(amount):
	initial_troops = amount
	hud.set_reinforcement_label(initial_troops)

func increment_initial_troops():
	initial_troops += 1
	hud.set_reinforcement_label(initial_troops)
	
func decrement_initial_troops():
	initial_troops -= 1
	hud.set_reinforcement_label(initial_troops)

func set_reinforcement(amount = 0):
	reinforcement = amount
	hud.set_reinforcement_label(reinforcement)

func increment_reinforcement(amount = 1):
	reinforcement += amount
	hud.set_reinforcement_label(reinforcement)

func decrement_reinforcement(amount = 1):
	reinforcement -= amount
	hud.set_reinforcement_label(reinforcement)

func setup_state():
	player_state.enter(self)

func all_troops_placed():
	var state = player_state.all_troops_placed(self)
	if state:
		change_state(state)

func change_state(state):
	print("Player ", name, " state changed.")
	var previous_state = player_state
	previous_state.exit(self)
	player_state = state
	print("Previous state: ", previous_state.get_class())
	print("New state: ", player_state.get_class())
	previous_state.queue_free()
	player_state.enter(self)

func setup_reinforcements():
	reinforcement = randi() % 10 + 3

func add_reinforcements(amount):
	reinforcement += amount
	# update hud

func _input(event):
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

func set_active(value):
	is_active = value
	if value:
		hud.show()
	else:
		hud.hide()
	set_process_input(value)

func country_clicked(country: Country):
	var state = player_state.country_clicked(self, country)
	if state:
		change_state(state)

func _process(delta):
	var state = player_state.update(self)
	if state:
		change_state(state)

func eliminate():
	eliminated = true
