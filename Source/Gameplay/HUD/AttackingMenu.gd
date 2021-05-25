extends TextureRect

class_name AttackingMenu

onready var player_icon = $Info/Players/Player/IconBorder/Icon
onready var player_name_label = $Info/Players/Player/Name
onready var player_country_label = $Info/Players/Player/Country
onready var player_troops_label = $Info/Players/Player/Troops

onready var opponent_icon = $Info/Players/Opponent/IconBorder/Icon
onready var opponent_name_label = $Info/Players/Opponent/Name
onready var opponent_country_label = $Info/Players/Opponent/Country
onready var opponent_troops_label = $Info/Players/Opponent/Troops

onready var troops_range = $Info/TroopsRange
onready var win_chance = $Info/WinChance

var player_country: Country = null
var opponent_country: Country = null
var win_chance_percentage = 0.0

signal attacked

func _ready():
	attack_details()

func attack_details(pc: Country = null, oc: Country = null):
	var troops = 0
	if pc == null:
		troops = 8
		troops_range.max_value = troops - 1
		troops_range.value = troops
		player_troops_label.text = str(troops)
	
	player_country = pc
	opponent_country = oc
	
	if player_country:
		player_country_label.text = player_country.get_name()
		troops_range.max_value = player_country.troops - 1
		troops_range.value = troops_range.max_value
		player_troops_label.text = str(player_country.troops)
		player_name_label.text = "Player " + player_country.occupier.name
		player_icon.color = GamePlay.colors[player_country.occupier.name]
	if opponent_country:
		opponent_country_label.text = opponent_country.get_name()
		opponent_troops_label.text = str(opponent_country.troops)
		opponent_name_label.text = "Player " + opponent_country.occupier.name
		opponent_icon.color = GamePlay.colors[opponent_country.occupier.name]
	
	if troops_range.value == 1:
		troops_range.suffix = "troop"
	else:
		troops_range.suffix = "troops"
	
	calculate_win_chance(troops_range.value)

func cancel():
	hide()

func attack():
	emit_signal("attacked", win_chance_percentage, troops_range.value, player_country, opponent_country)
	player_country = null
	opponent_country = null
	hide()

func value_changed(value):
	if value == 1:
		troops_range.suffix = "troop"
	else:
		troops_range.suffix = "troops"
	calculate_win_chance(value)

func calculate_win_chance(troops):
	win_chance_percentage = troops / 2.0
	var opponent_troops = 3
	if opponent_country:
		opponent_troops = opponent_country.troops
	win_chance_percentage = float(win_chance_percentage / opponent_troops) * 100.0
	if win_chance_percentage > 100:
		win_chance_percentage = 100
	win_chance.text = "Win Chance: " + str(stepify(win_chance_percentage, 0.1)) + "%"
	
